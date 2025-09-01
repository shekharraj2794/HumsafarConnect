//
//  ReusableComponents.swift
//  HumsafarConnect
//
//  Shared UI Components following Design System principles
//  Created by Raj Shekhar on 01/09/25.
//

import SwiftUI

// MARK: - Action Button Component

/// Reusable action button with haptic feedback and consistent styling
/// Used throughout the app for primary user actions
struct ActionButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let isDisabled: Bool
    let action: () async -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            guard !isDisabled else { return }
            
            // Provide haptic feedback for better user experience
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            Task {
                await action()
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: size, weight: .semibold))
                .foregroundColor(isDisabled ? .gray : color)
                .frame(width: 64, height: 64)
                .background(
                    Circle()
                        .fill(.regularMaterial)
                        .shadow(
                            color: DesignSystem.Shadow.medium.color,
                            radius: DesignSystem.Shadow.medium.radius,
                            x: DesignSystem.Shadow.medium.x,
                            y: DesignSystem.Shadow.medium.y
                        )
                )
                .overlay(
                    Circle()
                        .stroke(
                            isDisabled ? .gray.opacity(0.3) : color.opacity(0.2),
                            lineWidth: 2
                        )
                )
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            if !isDisabled {
                isPressed = pressing
            }
        } perform: { }
    }
}

// MARK: - Loading View Component

/// Loading overlay with animated spinner following design system
/// Provides consistent loading experience across the app
struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.lg) {
                ZStack {
                    Circle()
                        .stroke(DesignSystem.Colors.accent.opacity(0.3), lineWidth: 4)
                        .frame(width: 50, height: 50)

                    Circle()
                        .trim(from: 0, to: 0.3)
                        .stroke(DesignSystem.Colors.accent, lineWidth: 4)
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            .linear(duration: 1).repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }

                Text("Loading profiles...")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.text)
            }
            .padding(DesignSystem.Spacing.xl)
            .background(
                .ultraThickMaterial,
                in: RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Swipe Limit Overlay Component

/// Overlay displayed when user reaches daily swipe limit
/// Encourages premium upgrade with clear messaging
struct SwipeLimitView: View {
    let onUpgrade: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.lg) {
                limitReachedContent
                upgradeButton
            }
            .padding(DesignSystem.Spacing.xl)
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
            )
            .padding(.horizontal, 40)
        }
    }
    
    private var limitReachedContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(DesignSystem.Colors.primary)

            Text("Swipe Limit Reached!")
                .font(DesignSystem.Typography.title2)
                .fontWeight(.bold)

            Text("You've used all your daily swipes.\nUpgrade to premium for unlimited swipes!")
                .font(DesignSystem.Typography.body)
                .multilineTextAlignment(.center)
                .foregroundColor(DesignSystem.Colors.secondaryText)
        }
    }
    
    private var upgradeButton: some View {
        Button(action: onUpgrade) {
            Text("Upgrade Now")
                .font(DesignSystem.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(
                    LinearGradient(
                        colors: [DesignSystem.Colors.primary, DesignSystem.Colors.secondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 25)
                )
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Preview Support

#Preview("Action Button") {
    VStack(spacing: 20) {
        ActionButton(
            icon: "heart.fill",
            color: DesignSystem.Colors.success,
            size: 28,
            isDisabled: false
        ) {
            print("Like button tapped")
        }
        
        ActionButton(
            icon: "xmark",
            color: DesignSystem.Colors.error,
            size: 28,
            isDisabled: false
        ) {
            print("Pass button tapped")
        }
        
        ActionButton(
            icon: "message.fill",
            color: DesignSystem.Colors.accent,
            size: 24,
            isDisabled: true
        ) {
            print("Message button tapped")
        }
    }
    .padding()
}

#Preview("Loading View") {
    LoadingView()
}

#Preview("Swipe Limit View") {
    SwipeLimitView {
        print("Upgrade tapped")
    }
}

//
//  ProfileInfoComponents.swift
//  HumsafarConnect
//
//  Supporting components for MyProfileView
//  Created by Raj Shekhar on 01/09/25.
//

import SwiftUI

/// Reusable profile info section container with consistent styling
struct ProfileInfoSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(DesignSystem.Typography.headline)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.lg)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg))
    }
}

/// Profile info row with edit capability for future enhancements
struct ProfileInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .font(DesignSystem.Typography.body)

            Spacer()

            Button(action: {
                // Handle edit action - future enhancement
            }) {
                Image(systemName: "pencil")
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.primary)
            }
        }
    }
}
