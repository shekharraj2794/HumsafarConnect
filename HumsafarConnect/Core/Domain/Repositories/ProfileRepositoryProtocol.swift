//
//  ProfileRepository.swift
//  HumsafarConnect
//
//  Concrete Repository Implementation
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Concrete repository implementation coordinating data sources
/// Implements Repository pattern with fallback strategy for network failures
final class ProfileRepository: ProfileRepositoryProtocol, @unchecked Sendable {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    /// Initialize repository with data source dependencies
    /// - Parameters:
    ///   - remoteDataSource: Network data source for API calls
    ///   - localDataSource: Local storage for caching and persistence
    init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetchProfiles() async throws -> [Profile] {
        do {
            // Try to fetch from remote source first
            let profiles = try await remoteDataSource.fetchProfiles()
            // Cache successful response locally
            await localDataSource.cacheProfiles(profiles)
            return profiles
        } catch {
            // Fallback to local cache on network failure
            let cachedProfiles = await localDataSource.getCachedProfiles()
            if cachedProfiles.isEmpty {
                throw error // Re-throw if no cached data available
            }
            return cachedProfiles
        }
    }
    
    func fetchMoreProfiles() async throws -> [Profile] {
        return try await remoteDataSource.fetchMoreProfiles()
    }
    
    func saveSwipeAction(_ swipeAction: SwipeAction) async throws {
        // Save locally immediately for UI responsiveness
        await localDataSource.saveSwipeAction(swipeAction)
        
        // In production: Queue for remote sync when network available
        // try await remoteDataSource.syncSwipeAction(swipeAction)
    }
}
