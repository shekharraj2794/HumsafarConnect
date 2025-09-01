//
//  MyProfileView.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 02/09/25.
//
import SwiftUI
import Combine

// MARK: - MyProfileView (Temporary inclusion to fix scope error)

/// User's profile view with editable sections for managing personal information
/// This should ideally be in a separate file: Presentation/Views/MyProfileView.swift
struct MyProfileView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    profileImageSection
                    profileInfoSections
                    Spacer(minLength: 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        // Handle edit action - future enhancement
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
    }
    
    // MARK: - Profile Image Section
    
    private var profileImageSection: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: "https://picsum.photos/300/300?random=999")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: 4)
                    .shadow(radius: 10)
            )

            Button(action: {
                // Handle photo change action
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                    Text("Change Photo")
                }
                .font(DesignSystem.Typography.subheadline)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.primary)
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: Capsule())
            }
        }
        .padding(.top, DesignSystem.Spacing.lg)
    }
    
    // MARK: - Profile Information Sections
    
    private var profileInfoSections: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            ProfileInfoSection(title: "Basic Information") {
                VStack(spacing: 12) {
                    ProfileInfoRow(label: "Name", value: "Your Name")
                    ProfileInfoRow(label: "Age", value: "28 years")
                    ProfileInfoRow(label: "Location", value: "New York, USA")
                }
            }

            ProfileInfoSection(title: "Professional") {
                VStack(spacing: 12) {
                    ProfileInfoRow(label: "Occupation", value: "Software Engineer")
                    ProfileInfoRow(label: "Education", value: "Computer Science")
                    ProfileInfoRow(label: "Company", value: "Tech Corp")
                }
            }

            ProfileInfoSection(title: "About You") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bio")
                        .font(DesignSystem.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.secondaryText)

                    Text("I'm a passionate software engineer who loves creating innovative solutions. In my free time, I enjoy hiking, reading, and exploring new technologies.")
                        .font(DesignSystem.Typography.body)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }

            ProfileInfoSection(title: "Interests") {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100))
                ], spacing: 8) {
                    ForEach(["Technology", "Hiking", "Reading", "Travel", "Photography"], id: \.self) { interest in
                        Text(interest)
                            .font(DesignSystem.Typography.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(DesignSystem.Colors.primary.opacity(0.1), in: Capsule())
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
    }
}
