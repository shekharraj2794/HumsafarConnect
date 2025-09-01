//
//  SwipeAction.swift
//  HumsafarConnect
//
//  Domain Entity for Swipe Actions
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Swipe direction enumeration with clear business meaning
enum SwipeDirection: String, CaseIterable, Codable, Sendable {
    case left = "left"   // Reject/Pass
    case right = "right" // Like/Accept
}

/// Swipe action entity for tracking user interactions
/// Records all swipe decisions for analytics and matching logic
struct SwipeAction: Identifiable, Codable, Sendable {
    let id: String
    let profileId: String
    let direction: SwipeDirection
    let timestamp: Date
    
    /// Creates a new swipe action with current timestamp
    /// - Parameters:
    ///   - profileId: ID of the profile being swiped
    ///   - direction: Direction of the swipe (left/right)
    init(profileId: String, direction: SwipeDirection) {
        self.id = UUID().uuidString
        self.profileId = profileId
        self.direction = direction
        self.timestamp = Date()
    }
}
