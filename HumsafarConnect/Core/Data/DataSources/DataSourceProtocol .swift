//
//  DataSourceProtocols.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Protocol for remote data source operations (API/Network)
/// Defines contract for network-based data operations
protocol RemoteDataSourceProtocol: Sendable {
    /// Fetches profiles from remote API
    /// - Returns: Array of Profile entities from server
    /// - Throws: Network or parsing errors
    func fetchProfiles() async throws -> [Profile]
    
    /// Fetches additional profiles for pagination from remote API
    /// - Returns: Array of additional Profile entities
    /// - Throws: Network or parsing errors
    func fetchMoreProfiles() async throws -> [Profile]
}

/// Protocol for local data source operations (Caching/Persistence)
/// Defines contract for local storage operations
protocol LocalDataSourceProtocol: Sendable {
    /// Caches profiles locally for offline access
    /// - Parameter profiles: Array of profiles to cache
    func cacheProfiles(_ profiles: [Profile]) async
    
    /// Retrieves cached profiles from local storage
    /// - Returns: Array of cached Profile entities
    func getCachedProfiles() async -> [Profile]
    
    /// Saves swipe action to local storage
    /// - Parameter swipeAction: SwipeAction to persist locally
    func saveSwipeAction(_ swipeAction: SwipeAction) async
}
