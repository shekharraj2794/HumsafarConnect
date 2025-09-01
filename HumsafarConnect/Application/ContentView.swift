//
//  ContentView.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//

import SwiftUI

/// Root content view coordinating app flow and user interactions
/// Implements pure MVVM pattern with ProfileViewModel
struct ContentView: View {
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                VStack(spacing: DesignSystem.Spacing.lg) {
                    headerView
                    cardStackView
                    actionButtonsView
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                
                if profileViewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $appState.selectedProfile) { profile in
                ProfileDetailView(
                    profile: profile,
                    onLike: {
                        Task {
                            await handleSwipe(direction: .right, profile: profile)
                        }
                    },
                    onPass: {
                        Task {
                            await handleSwipe(direction: .left, profile: profile)
                        }
                    },
                    onMessage: {
                        // Handle message action - implement chat functionality
                        print("Message tapped for profile: \(profile.id)")
                    }
                )
            }
            .sheet(isPresented: $appState.showingMyProfile) {
                MyProfileView()
            }
            .fullScreenCover(isPresented: $appState.showingPurchasePopup) {
                PurchasePopupView(isVisible: $appState.showingPurchasePopup) {
                    appState.resetSwipeCount()
                }
            }
            .task {
                await profileViewModel.loadProfiles()
            }
        }
    }
    
    // MARK: - View Components
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [DesignSystem.Colors.background, DesignSystem.Colors.secondaryBackground],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        HStack {
            profileImageButton
            Spacer()
            brandingSection
            Spacer()
            swipeCounterView
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
    
    private var profileImageButton: some View {
        Button(action: appState.showMyProfileScreen) {
            AsyncImage(url: URL(string: "https://picsum.photos/50/50?random=999")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(.ultraThinMaterial)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [DesignSystem.Colors.secondary, DesignSystem.Colors.primary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
        }
    }
    
    private var brandingSection: some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Humsafar")
                .font(DesignSystem.Typography.largeTitle)
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text("Find your life partner")
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(DesignSystem.Colors.text)
                .fontWeight(.medium)
        }
    }
    
    private var swipeCounterView: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("\(appState.remainingSwipes)")
                .font(DesignSystem.Typography.title2)
                .fontWeight(.semibold)
                .foregroundColor(appState.hasReachedSwipeLimit ? DesignSystem.Colors.error : DesignSystem.Colors.text)
            
            Text("swipes left")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.text)
                .fontWeight(.medium)
        }
    }
    
    private var cardStackView: some View {
        ZStack {
            ForEach(Array(profileViewModel.profiles.enumerated().reversed()), id: \.element.id) { index, profile in
                if index >= profileViewModel.currentIndex && index < profileViewModel.currentIndex + 3 {
                    ProfileCard(
                        profile: profile,
                        offset: CGFloat(index - profileViewModel.currentIndex),
                        isTopCard: index == profileViewModel.currentIndex,
                        isDisabled: appState.hasReachedSwipeLimit,
                        onSwipe: { direction in
                            await handleSwipe(direction: direction, profile: profile)
                        },
                        onTap: {
                            // FIX: Set selectedProfile in appState to trigger navigation
                            print("Card tapped for profile: \(profile.id)") // Debug log
                            appState.selectedProfile = profile
                        }
                    )
                    .zIndex(Double(profileViewModel.profiles.count - index))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Group {
                if appState.hasReachedSwipeLimit {
                    SwipeLimitView {
                        appState.showPurchaseScreen()
                    }
                }
            }
        )
    }
    
    private var actionButtonsView: some View {
        HStack(spacing: 60) {
            ActionButton(
                icon: "xmark",
                color: DesignSystem.Colors.error,
                size: 28,
                isDisabled: appState.hasReachedSwipeLimit
            ) {
                if let profile = profileViewModel.currentProfile {
                    await handleSwipe(direction: .left, profile: profile)
                }
            }
            
            ActionButton(
                icon: "heart.fill",
                color: DesignSystem.Colors.success,
                size: 28,
                isDisabled: appState.hasReachedSwipeLimit
            ) {
                if let profile = profileViewModel.currentProfile {
                    await handleSwipe(direction: .right, profile: profile)
                }
            }
        }
        .padding(.bottom, 30)
    }
    
    // MARK: - Swipe Handling
    
    private func handleSwipe(direction: SwipeDirection, profile: Profile) async {
        guard !appState.hasReachedSwipeLimit else {
            appState.showPurchaseScreen()
            return
        }
        
        // Add haptic feedback for better UX
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Process swipe through ViewModel (MVVM pattern)
        await profileViewModel.handleSwipe(direction: direction, profile: profile)
        
        // Update app state for swipe count
        appState.incrementSwipeCount()
        
        // Show purchase popup if limit reached
        if appState.hasReachedSwipeLimit {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appState.showPurchaseScreen()
            }
        }
    }
}
