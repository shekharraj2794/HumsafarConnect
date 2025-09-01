//
//  SwipeRepositoryProtocol.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//

/// Protocol for swipe repository operations
protocol SwipeRepositoryProtocol: Sendable {
    /// Saves a swipe action to storage
    /// - Parameter swipeAction: SwipeAction to persist
    /// - Throws: Storage errors
    func saveSwipe(_ swipeAction: SwipeAction) async throws
    
    /// Retrieves swipe history from storage
    /// - Returns: Array of SwipeAction entities
    /// - Throws: Storage errors
    func fetchSwipeHistory() async throws -> [SwipeAction]
}
