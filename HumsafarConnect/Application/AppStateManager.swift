//
//  AppStateManager.swift
//  HumsafarConnect
//
//  Application State Management following MVVM pattern
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Manages global application state and UI flow
/// Follows Single Responsibility Principle - focused only on app-wide state
@MainActor
final class AppStateManager: ObservableObject {
    
    // MARK: - Navigation State
    @Published var selectedProfile: Profile?
    @Published var showingMyProfile = false
    @Published var showingPurchasePopup = false
    
    // MARK: - Swipe Limitation Business Logic
    @Published private(set) var swipeCount = 0
    private let maxSwipes = 10
    
    // MARK: - Computed Properties
    
    /// Determines if user has reached daily swipe limit
    var hasReachedSwipeLimit: Bool {
        swipeCount >= maxSwipes
    }
    
    /// Calculates remaining swipes for display
    var remainingSwipes: Int {
        max(0, maxSwipes - swipeCount)
    }
    
    // MARK: - Public Methods
    
    /// Shows profile detail view for selected profile
    /// - Parameter profile: Profile to display in detail view
    func showProfileDetail(_ profile: Profile) {
        selectedProfile = profile
    }
    
    /// Triggers display of user's own profile screen
    func showMyProfileScreen() {
        showingMyProfile = true
    }
    
    /// Triggers display of premium purchase screen
    func showPurchaseScreen() {
        showingPurchasePopup = true
    }
    
    /// Increments swipe count when user performs swipe action
    func incrementSwipeCount() {
        swipeCount += 1
    }
    
    /// Resets swipe count after premium purchase or daily reset
    func resetSwipeCount() {
        swipeCount = 0
    }
}
