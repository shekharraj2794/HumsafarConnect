//
//  RemoteDataSource.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Mock remote data source for development and testing
/// In production, this would integrate with actual REST API or GraphQL
actor RemoteDataSource: RemoteDataSourceProtocol {
    
    func fetchProfiles() async throws -> [Profile] {
        // Simulate network delay for realistic testing
        try await Task.sleep(for: .seconds(1))
        
        // Return shuffled profiles to simulate dynamic content
        return Profile.examples.shuffled()
    }
    
    func fetchMoreProfiles() async throws -> [Profile] {
        // Simulate shorter network delay for pagination
        try await Task.sleep(for: .milliseconds(500))
        
        // Generate additional profiles with randomized data
        return Profile.examples.shuffled().map { profile in
            Profile(
                name: profile.name,
                age: Int.random(in: 22...35),
                bio: profile.bio,
                occupation: profile.occupation,
                education: profile.education,
                lookingFor: profile.lookingFor,
                distance: Int.random(in: 1...15),
                imageURL: "https://picsum.photos/400/600?random=\(Int.random(in: 100...200))",
                photos: [
                    "https://picsum.photos/400/600?random=\(Int.random(in: 100...200))",
                    "https://picsum.photos/400/600?random=\(Int.random(in: 201...300))",
                    "https://picsum.photos/400/600?random=\(Int.random(in: 301...400))"
                ],
                interests: profile.interests
            )
        }
    }
}

// MARK: - Production Implementation Reference
/*
 In production, this would look like:
 
 actor RemoteDataSource: RemoteDataSourceProtocol {
     private let apiClient: APIClient
     private let baseURL = "https://api.humsafarconnect.com/v1"
     
     init(apiClient: APIClient = APIClient()) {
         self.apiClient = apiClient
     }
     
     func fetchProfiles() async throws -> [Profile] {
         let endpoint = "\(baseURL)/profiles"
         let profileDTOs: [ProfileDTO] = try await apiClient.get(endpoint)
         return profileDTOs.map { $0.toDomain() }
     }
     
     func fetchMoreProfiles() async throws -> [Profile] {
         let endpoint = "\(baseURL)/profiles/more"
         let profileDTOs: [ProfileDTO] = try await apiClient.get(endpoint)
         return profileDTOs.map { $0.toDomain() }
     }
     
     func syncSwipeAction(_ swipeAction: SwipeAction) async throws {
         let endpoint = "\(baseURL)/swipes"
         let swipeDTO = SwipeDTO(from: swipeAction)
         try await apiClient.post(endpoint, body: swipeDTO)
     }
 }
*/
