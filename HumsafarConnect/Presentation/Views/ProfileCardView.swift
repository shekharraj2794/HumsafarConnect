//
//  ProfileCard.swift
//  HumsafarConnect
//
//  Swipeable Profile Card Component with Gesture Handling
//  Created by Raj Shekhar on 01/09/25.
//

import SwiftUI

/// Interactive profile card with swipe gestures and visual feedback
/// Implements card stack behavior with smooth animations
struct ProfileCard: View {
    let profile: Profile
    let offset: CGFloat
    let isTopCard: Bool
    let isDisabled: Bool
    let onSwipe: (SwipeDirection) async -> Void
    let onTap: () -> Void

    @State private var dragOffset = CGSize.zero
    @State private var rotationAngle: Double = 0
    @State private var isPressed = false

    private let cardWidth: CGFloat = 340
    private let cardHeight: CGFloat = 520

    var body: some View {
        ZStack {
            cardContent
                .frame(width: cardWidth, height: cardHeight)
                .scaleEffect(isTopCard ? 1.0 : 1.0 - (offset * 0.05))
                .offset(
                    x: isTopCard ? dragOffset.width : 0,
                    y: isTopCard ? dragOffset.height : offset * -10
                )
                .rotationEffect(.degrees(isTopCard ? rotationAngle : 0))
                .opacity(isTopCard ? (isDisabled ? 0.6 : 1.0) : 1.0 - (offset * 0.3))
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
                .gesture(cardDragGesture)
                .onTapGesture(perform: handleTap)

            // Swipe indicators
            if isTopCard && !isDisabled && abs(dragOffset.width) > 50 {
                swipeIndicatorOverlay
            }

            // Disabled overlay
            if isDisabled && isTopCard {
                disabledOverlay
            }
        }
    }

    // MARK: - Card Content Components
    
    private var cardContent: some View {
        ZStack {
            cardBackground
            VStack(spacing: 0) {
                profileImage
                profileInfo
            }
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
            .fill(.ultraThinMaterial)
            .shadow(
                color: DesignSystem.Shadow.medium.color,
                radius: isTopCard ? DesignSystem.Shadow.medium.radius * 2.5 : DesignSystem.Shadow.medium.radius,
                x: DesignSystem.Shadow.medium.x,
                y: isTopCard ? DesignSystem.Shadow.medium.y * 3 : DesignSystem.Shadow.medium.y * 1.5
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }

    private var profileImage: some View {
        AsyncImage(url: URL(string: profile.imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay {
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("Loading...")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                }
        }
        .frame(height: 360)
        .clipped()
        .overlay(imageGradient)
    }

    private var imageGradient: some View {
        LinearGradient(
            colors: [.clear, .clear, .black.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var profileInfo: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            profileHeader
            profileBio
            interestsScroll
        }
        .padding(DesignSystem.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var profileHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(DesignSystem.Typography.title2)
                    .fontWeight(.semibold)

                HStack(spacing: 4) {
                    Text("\(profile.age) years")
                    Text("•")
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                    Text(profile.occupation.isEmpty ? "Professional" : profile.occupation)
                }
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(DesignSystem.Colors.secondaryText)
            }

            Spacer()
            distanceBadge
        }
    }

    private var distanceBadge: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.caption2)
                Text("\(profile.distance) km")
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())

            // Verification badge
            HStack(spacing: 2) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.accent)
                Text("Verified")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.accent)
            }
        }
    }

    @ViewBuilder
    private var profileBio: some View {
        if !profile.bio.isEmpty {
            Text(profile.bio)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .lineLimit(2)
        }
    }

    private var interestsScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(profile.interests.prefix(3), id: \.self) { interest in
                    Text(interest)
                        .font(DesignSystem.Typography.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(DesignSystem.Colors.primary.opacity(0.1), in: Capsule())
                        .foregroundColor(DesignSystem.Colors.primary)
                }
            }
            .padding(.horizontal, 1)
        }
    }

    // MARK: - Overlay Components
    
    @ViewBuilder
    private var swipeIndicatorOverlay: some View {
        VStack {
            HStack {
                if dragOffset.width < 0 {
                    Spacer()
                }

                HStack(spacing: 6) {
                    Image(systemName: dragOffset.width > 0 ? "heart.fill" : "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    Text(dragOffset.width > 0 ? "LIKE" : "NOPE")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 120, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(dragOffset.width > 0 ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        .opacity(0.9)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 2)
                )
                .opacity(min(abs(dragOffset.width) / 100.0, 1.0))
                .scaleEffect(0.9 + (min(abs(dragOffset.width) / 150.0, 1.0) * 0.2))
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)

                if dragOffset.width > 0 {
                    Spacer()
                }
            }
            .padding(.top, 60)

            Spacer()
        }
        .padding(.horizontal, 30)
    }

    private var disabledOverlay: some View {
        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
            .fill(Color.black.opacity(0.4))
            .overlay(
                VStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    Text("Swipe Limit Reached")
                        .font(DesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text("Upgrade to continue")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            )
    }

    // MARK: - Gesture Handling
    
    private var cardDragGesture: some Gesture {
        isTopCard && !isDisabled ?
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
                rotationAngle = Double(value.translation.width / 10.0)
            }
            .onEnded(handleDragEnd) : nil
    }

    private func handleDragEnd(_ value: DragGesture.Value) {
        let swipeThreshold: CGFloat = 100

        if abs(value.translation.width) > swipeThreshold {
            let direction: SwipeDirection = value.translation.width > 0 ? .right : .left

            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                dragOffset = CGSize(
                    width: value.translation.width > 0 ? 500 : -500,
                    height: value.translation.height
                )
                rotationAngle = Double(dragOffset.width / 5.0)
            }

            Task {
                await onSwipe(direction)
            }
        } else {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                dragOffset = .zero
                rotationAngle = 0
            }
        }
    }

    private func handleTap() {
        if !isDisabled {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                onTap()
            }
        }
    }
}
