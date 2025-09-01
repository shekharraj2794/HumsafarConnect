//
//  SwipeUseCaseProtocol.swift
//  HumsafarConnect
//
//  Swipe Use Case - Business Logic for Swipe Operations
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Protocol defining swipe-related business operations
/// Follows Single Responsibility Principle - focused on swipe logic only
protocol SwipeUseCaseProtocol: Sendable {
    /// Processes a swipe action and handles business rules
    /// - Parameter swipeAction: The swipe action to process
    /// - Throws: Business logic or data access errors
    func processSwipe(_ swipeAction: SwipeAction) async throws
    
    /// Retrieves swipe history for analytics or user review
    /// - Returns: Array of historical swipe actions
    /// - Throws: Data access errors
    func getSwipeHistory() async throws -> [SwipeAction]
}

/// Concrete implementation of swipe business logic
/// Coordinates with repository layer for data persistence
actor SwipeUseCase: SwipeUseCaseProtocol {
    private let repository: SwipeRepositoryProtocol
    
    /// Initialize with repository dependency injection
    /// - Parameter repository: Repository for swipe data operations
    init(repository: SwipeRepositoryProtocol) {
        self.repository = repository
    }
    
    func processSwipe(_ swipeAction: SwipeAction) async throws {
        // Business logic: validate swipe action
        // In production: implement matching logic, rate limiting, etc.
        try await repository.saveSwipe(swipeAction)
    }
    
    func getSwipeHistory() async throws -> [SwipeAction] {
        return try await repository.fetchSwipeHistory()
    }
}

