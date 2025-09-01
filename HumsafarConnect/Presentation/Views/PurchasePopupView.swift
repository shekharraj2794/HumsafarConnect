//
//  PurchasePopupView.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 02/09/25.
//

import SwiftUI

/// Premium subscription purchase view with multiple plan options and feature showcase
/// Implements conversion-optimized design patterns for subscription upgrades
struct PurchasePopupView: View {
    @Binding var isVisible: Bool
    let onPurchaseComplete: () -> Void

    @State private var selectedPlan = 1

    private let plans = [
        PurchasePlan(months: 1, monthlyPrice: 29.99, totalPrice: 29.99, discount: nil, tag: nil),
        PurchasePlan(months: 3, monthlyPrice: 19.99, totalPrice: 59.99, discount: 33, tag: "MOST POPULAR"),
        PurchasePlan(months: 6, monthlyPrice: 14.99, totalPrice: 89.99, discount: 50, tag: "BEST VALUE")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                featuresCarousel
                Spacer()
                pricingSection
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Upgrade to Premium")
                .font(DesignSystem.Typography.largeTitle)
                .foregroundColor(.white)

            Text("Unlimited swipes and premium features")
                .font(DesignSystem.Typography.title3)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 60)
        .padding(.bottom, 30)
    }
    
    // MARK: - Features Carousel
    
    private var featuresCarousel: some View {
        TabView {
            FeatureCard(
                icon: "heart.fill",
                title: "Unlimited Swipes",
                description: "Connect with as many people as you want"
            )

            FeatureCard(
                icon: "eye.fill",
                title: "See Who Likes You",
                description: "Know who's interested before you swipe"
            )

            FeatureCard(
                icon: "bolt.fill",
                title: "Super Powers",
                description: "Boost your profile and get more matches"
            )
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 200)
    }
    
    // MARK: - Pricing Section
    
    private var pricingSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            planSelectionView
            purchaseButton
            cancelButton
            legalText
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThickMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private var planSelectionView: some View {
        HStack(spacing: 12) {
            ForEach(0..<plans.count, id: \.self) { index in
                PurchasePlanView(
                    plan: plans[index],
                    isSelected: selectedPlan == index
                )
                .onTapGesture {
                    selectedPlan = index
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
    }
    
    private var purchaseButton: some View {
        Button(action: {
            onPurchaseComplete()
            isVisible = false
        }) {
            Text("Continue with \(plans[selectedPlan].months) month\(plans[selectedPlan].months > 1 ? "s" : "")")
                .font(DesignSystem.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 28)
                )
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
    }
    
    private var cancelButton: some View {
        Button("No Thanks") {
            isVisible = false
        }
        .font(DesignSystem.Typography.headline)
        .foregroundColor(.white.opacity(0.6))
        .padding(.top, 10)
    }
    
    private var legalText: some View {
        Text("Recurring billing, cancel anytime.\nSafe and secure payment.")
            .font(DesignSystem.Typography.caption)
            .multilineTextAlignment(.center)
            .foregroundColor(.white.opacity(0.5))
            .padding(.top, DesignSystem.Spacing.lg)
            .padding(.bottom, 40)
    }
}

// MARK: - Supporting Data Models

/// Data model for purchase plans with pricing information
struct PurchasePlan {
    let months: Int
    let monthlyPrice: Double
    let totalPrice: Double
    let discount: Int?
    let tag: String?
}

/// Feature card component for premium features showcase
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.yellow)

            Text(title)
                .font(DesignSystem.Typography.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(description)
                .font(DesignSystem.Typography.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 40)
    }
}

/// Individual purchase plan view with selection state visualization
struct PurchasePlanView: View {
    let plan: PurchasePlan
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            planTagView
            
            Text("\(plan.months)")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(isSelected ? .black : .white)

            Text("month\(plan.months > 1 ? "s" : "")")
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(isSelected ? .black : .white.opacity(0.7))

            Text("$\(String(format: "%.2f", plan.monthlyPrice))/mo")
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(isSelected ? .black : .white.opacity(0.7))

            if let discount = plan.discount {
                Text("SAVE \(discount)%")
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }

            Text("$\(String(format: "%.2f", plan.totalPrice))")
                .font(DesignSystem.Typography.headline)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .black : .white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? .white : .clear)
                .stroke(isSelected ? .clear : .white.opacity(0.3), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private var planTagView: some View {
        if let tag = plan.tag {
            Text(tag)
                .font(DesignSystem.Typography.caption)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.yellow, in: Capsule())
        } else {
            Spacer()
                .frame(height: 20)
        }
    }
}
