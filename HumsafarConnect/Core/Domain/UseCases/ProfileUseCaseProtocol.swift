//
//  ProfileUseCaseProtocol.swift
//  HumsafarConnect
//
//  Domain Use Case - Business Logic Interface
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Protocol defining profile-related business operations
/// Follows Interface Segregation Principle - focused on profile operations only
protocol ProfileUseCaseProtocol: Sendable {
    /// Loads initial set of profiles for the user
    /// - Returns: Array of Profile entities
    /// - Throws: NetworkError or DataError
    func loadProfiles() async throws -> [Profile]
    
    /// Loads additional profiles for infinite scrolling
    /// - Returns: Array of additional Profile entities
    /// - Throws: NetworkError or DataError
    func loadMoreProfiles() async throws -> [Profile]
    
    /// Processes a swipe action and updates backend/local storage
    /// - Parameter swipeAction: The swipe action to process
    /// - Throws: NetworkError or DataError
    func processSwipe(_ swipeAction: SwipeAction) async throws
}

/// Concrete implementation of profile business logic
/// Uses Repository pattern for data access abstraction
actor ProfileUseCase: ProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    /// Initialize with repository dependency injection
    /// - Parameter repository: Repository for data operations
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadProfiles() async throws -> [Profile] {
        return try await repository.fetchProfiles()
    }
    
    func loadMoreProfiles() async throws -> [Profile] {
        return try await repository.fetchMoreProfiles()
    }
    
    func processSwipe(_ swipeAction: SwipeAction) async throws {
        try await repository.saveSwipeAction(swipeAction)
    }
}
