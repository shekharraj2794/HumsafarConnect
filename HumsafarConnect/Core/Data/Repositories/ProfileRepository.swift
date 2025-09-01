//
//  ProfileRepositoryProtocol.swift
//  HumsafarConnect
//
//  Repository Interface - Data Access Contract
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Repository protocol defining data operations contract
/// Abstracts data sources from business logic following Dependency Inversion Principle
protocol ProfileRepositoryProtocol: Sendable {
    /// Fetches initial profiles from data source
    /// - Returns: Array of Profile entities
    /// - Throws: Data access errors
    func fetchProfiles() async throws -> [Profile]
    
    /// Fetches additional profiles for pagination
    /// - Returns: Array of additional Profile entities
    /// - Throws: Data access errors
    func fetchMoreProfiles() async throws -> [Profile]
    
    /// Saves swipe action to appropriate storage
    /// - Parameter swipeAction: The swipe action to persist
    /// - Throws: Storage errors
    func saveSwipeAction(_ swipeAction: SwipeAction) async throws
}
