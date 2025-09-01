//
//  ProfileViewModel.swift
//  HumsafarConnect
//
//  Profile ViewModel following MVVM pattern with Clean Architecture
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation
import SwiftUI

/// Profile ViewModel implementing MVVM pattern with dependency injection
/// Manages profile-related UI state and coordinates with business logic layer
@MainActor
final class ProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI State)
    
    @Published private(set) var profiles: [Profile] = []
    @Published private(set) var currentIndex = 0
    @Published private(set) var isLoading = false
    @Published private(set) var swipeCount = 0
    @Published var showingDetail = false
    @Published var selectedProfile: Profile?
    
    // MARK: - Business Logic Dependencies
    
    private let profileUseCase: ProfileUseCaseProtocol
    private let swipeUseCase: SwipeUseCaseProtocol
    private let maxSwipes = 10
    
    // MARK: - Initialization
    
    /// Initialize ViewModel with injected use cases
    /// - Parameters:
    ///   - profileUseCase: Use case for profile operations
    ///   - swipeUseCase: Use case for swipe operationsa
    init(profileUseCase: ProfileUseCaseProtocol, swipeUseCase: SwipeUseCaseProtocol) {
        self.profileUseCase = profileUseCase
        self.swipeUseCase = swipeUseCase
    }
    
    // MARK: - Computed Properties
    
    /// Determines if user has reached daily swipe limit
    var hasReachedSwipeLimit: Bool {
        swipeCount >= maxSwipes
    }
    
    /// Calculates remaining swipes for UI display
    var remainingSwipes: Int {
        max(0, maxSwipes - swipeCount)
    }
    
    /// Gets the current profile being displayed
    var currentProfile: Profile? {
        guard currentIndex < profiles.count else { return nil }
        return profiles[currentIndex]
    }
    
    // MARK: - Public Methods (Intent Actions)
    
    /// Loads initial set of profiles from business layer
    /// Updates UI state accordingly
    func loadProfiles() async {
        isLoading = true
        
        do {
            profiles = try await profileUseCase.loadProfiles()
        } catch {
            // Handle error gracefully - in production, show user-friendly error
            print("Error loading profiles: \(error)")
        }
        
        isLoading = false
    }
    
    /// Loads additional profiles for infinite scrolling
    /// Called when user approaches end of profile stack
    func loadMoreProfiles() async {
        guard currentIndex >= profiles.count - 2 else { return }
        
        do {
            let moreProfiles = try await profileUseCase.loadMoreProfiles()
            profiles.append(contentsOf: moreProfiles)
        } catch {
            print("Error loading more profiles: \(error)")
        }
    }
    
    /// Handles swipe action with business logic processing
    /// - Parameters:
    ///   - direction: Direction of swipe (left/right)
    ///   - profile: Profile being swiped
    func handleSwipe(direction: SwipeDirection, profile: Profile) async {
        guard !hasReachedSwipeLimit else { return }
        
        let swipeAction = SwipeAction(profileId: profile.id, direction: direction)
        
        do {
            try await swipeUseCase.processSwipe(swipeAction)
            
            // Update UI state after successful business logic execution
            swipeCount += 1
            currentIndex += 1
            
            // Trigger loading more profiles if needed
            await loadMoreProfiles()
            
        } catch {
            print("Error processing swipe: \(error)")
        }
    }
    
    /// Shows profile detail view for selected profile
    /// - Parameter profile: Profile to display in detail
    func showProfileDetail(profile: Profile) {
        selectedProfile = profile
        showingDetail = true
    }
    
    /// Resets swipe count (typically after premium purchase)
    func resetSwipeCount() {
        swipeCount = 0
    }
}
