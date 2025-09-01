//
//  SwipeRepository.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//

/// Swipe repository implementation
final class SwipeRepository: SwipeRepositoryProtocol, @unchecked Sendable {
    private var swipeHistory: [SwipeAction] = []
    
    func saveSwipe(_ swipeAction: SwipeAction) async throws {
        swipeHistory.append(swipeAction)
        // In real app, save to persistent storage or send to server
    }
    
    func fetchSwipeHistory() async throws -> [SwipeAction] {
        return swipeHistory
    }
}
