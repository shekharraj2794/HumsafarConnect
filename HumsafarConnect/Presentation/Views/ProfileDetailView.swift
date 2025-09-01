//
//  ProfileDetailView.swift
//  HumsafarConnect
//
//  Detailed Profile View with Photo Carousel and Complete Information
//  Created by Raj Shekhar on 01/09/25.
//

import SwiftUI

/// Detailed profile view with full-screen photo carousel and comprehensive profile information
/// Provides immersive experience for viewing potential matches
struct ProfileDetailView: View {
    let profile: Profile
    @Environment(\.dismiss) private var dismiss
    @State private var currentImageIndex = 0
    @State private var showingFullBio = false
    
    // MARK: - Callback Actions
    let onLike: () -> Void
    let onPass: () -> Void
    let onMessage: () -> Void
    
    init(profile: Profile, onLike: @escaping () -> Void = {}, onPass: @escaping () -> Void = {}, onMessage: @escaping () -> Void = {}) {
        self.profile = profile
        self.onLike = onLike
        self.onPass = onPass
        self.onMessage = onMessage
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    photoCarousel
                    profileDetailsSection
                }
            }
            .background(Color.white)
            .ignoresSafeArea()
            
            closeButton
            actionButtons
        }
    }
    
    // MARK: - Photo Carousel
    
    private var photoCarousel: some View {
        TabView(selection: $currentImageIndex) {
            ForEach(0..<profile.photos.count, id: \.self) { index in
                AsyncImage(url: URL(string: profile.photos[index])) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            ProgressView()
                                .tint(.gray)
                        }
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .clipped()
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: UIScreen.main.bounds.height * 0.6)
    }
    
    // MARK: - Profile Details Section
    
    private var profileDetailsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            basicInfoSection
            Divider()
            bioSection
            Divider()
            interestsSection
            Divider()
            quickFactsSection
            
            Spacer()
                .frame(height: 120)
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.top, 30)
        .background(Color.white)
    }
    
    private var basicInfoSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(profile.name)
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(.black)
                    
                    Text("\(profile.age)")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.primary)
                    Text("\(profile.distance) km away")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundColor(.gray)
                }
                
                if !profile.occupation.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "briefcase.fill")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.primary)
                        Text(profile.occupation)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            verificationBadge
        }
    }
    
    private var verificationBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(DesignSystem.Colors.accent)
            Text("Verified")
                .font(DesignSystem.Typography.caption)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.accent)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(DesignSystem.Colors.accent.opacity(0.1))
        .clipShape(Capsule())
    }
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(DesignSystem.Typography.headline)
                .foregroundColor(.black)
            
            Text(profile.bio)
                .font(DesignSystem.Typography.body)
                .foregroundColor(.black)
                .lineLimit(showingFullBio ? nil : 3)
            
            if profile.bio.count > 150 {
                Button(showingFullBio ? "Show less" : "Read more") {
                    withAnimation {
                        showingFullBio.toggle()
                    }
                }
                .font(DesignSystem.Typography.subheadline)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.primary)
            }
        }
    }
    
    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Interests")
                .font(DesignSystem.Typography.headline)
                .foregroundColor(.black)
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100))
            ], spacing: 8) {
                ForEach(profile.interests, id: \.self) { interest in
                    Text(interest)
                        .font(DesignSystem.Typography.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(DesignSystem.Colors.primary.opacity(0.1))
                        .foregroundColor(DesignSystem.Colors.primary)
                        .clipShape(Capsule())
                }
            }
        }
    }
    
    private var quickFactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Facts")
                .font(DesignSystem.Typography.headline)
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                ProfileDetailRow(icon: "briefcase.fill", title: "Occupation", value: profile.occupation)
                ProfileDetailRow(icon: "graduationcap.fill", title: "Education", value: profile.education)
                ProfileDetailRow(icon: "heart.fill", title: "Looking for", value: profile.lookingFor)
            }
        }
    }
    
    // MARK: - Overlay Components
    
    private var closeButton: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(DesignSystem.Typography.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(.leading, DesignSystem.Spacing.lg)
                .padding(.top, 28)
                
                Spacer()
            }
            
            Spacer()
        }
    }
    
    private var actionButtons: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 40) {
                ActionButton(
                    icon: "xmark",
                    color: DesignSystem.Colors.error,
                    size: 24,
                    isDisabled: false
                ) {
                    onPass()
                    dismiss()
                }
                
                ActionButton(
                    icon: "heart.fill",
                    color: DesignSystem.Colors.success,
                    size: 24,
                    isDisabled: false
                ) {
                    onLike()
                    dismiss()
                }
                
                ActionButton(
                    icon: "message.fill",
                    color: DesignSystem.Colors.accent,
                    size: 20,
                    isDisabled: false
                ) {
                    onMessage()
                }
            }
            .padding(.bottom, 50)
        }
    }
}

/// Profile detail row component for displaying key-value information
struct ProfileDetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(DesignSystem.Colors.primary)
                .frame(width: 20)

            Text(title)
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)

            Text(value.isEmpty ? "Not specified" : value)
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(value.isEmpty ? .gray : .black)

            Spacer()
        }
    }
}
