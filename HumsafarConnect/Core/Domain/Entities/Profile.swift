//
//  Profile.swift
//  HumsafarConnect
//
//  Domain Entity - Core business model
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Domain entity representing a user profile
/// Conforms to Sendable for strict concurrency safety
struct Profile: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let name: String
    let age: Int
    let bio: String
    let occupation: String
    let education: String
    let lookingFor: String
    let distance: Int
    let imageURL: String
    let photos: [String]
    let interests: [String]
    
    /// Initializer with sensible defaults following business rules
    init(
        id: String = UUID().uuidString,
        name: String,
        age: Int,
        bio: String,
        occupation: String = "",
        education: String = "",
        lookingFor: String = "",
        distance: Int,
        imageURL: String,
        photos: [String] = [],
        interests: [String] = []
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.bio = bio
        self.occupation = occupation
        self.education = education
        self.lookingFor = lookingFor
        self.distance = distance
        self.imageURL = imageURL
        self.photos = photos.isEmpty ? [imageURL] : photos
        self.interests = interests
    }
}

// MARK: - Mock Data Extension
extension Profile {
    /// Static mock data for development and testing
    static let examples: [Profile] = [
        Profile(
            name: "Emma Watson",
            age: 28,
            bio: "Love reading books, hiking in nature, and exploring new coffee shops. Currently working on sustainable fashion initiatives. Looking for meaningful conversations and genuine connections! ✨",
            occupation: "Environmental Consultant",
            education: "Harvard University",
            lookingFor: "Long-term relationship",
            distance: 3,
            imageURL: "https://picsum.photos/400/600?random=1",
            photos: [
                "https://picsum.photos/400/600?random=1",
                "https://picsum.photos/400/600?random=11",
                "https://picsum.photos/400/600?random=21"
            ],
            interests: ["Reading", "Hiking", "Coffee", "Sustainability", "Travel"]
        ),
        Profile(
            name: "James Rodriguez",
            age: 32,
            bio: "Professional photographer who loves capturing life's beautiful moments. Weekend warrior on the mountain bike trails. Always up for a spontaneous adventure! 📸",
            occupation: "Photographer",
            education: "Art Institute",
            lookingFor: "Something casual",
            distance: 7,
            imageURL: "https://picsum.photos/400/600?random=2",
            photos: [
                "https://picsum.photos/400/600?random=2",
                "https://picsum.photos/400/600?random=12",
                "https://picsum.photos/400/600?random=22"
            ],
            interests: ["Photography", "Mountain Biking", "Travel", "Art", "Adventure"]
        ),
        Profile(
            name: "Sofia Chen",
            age: 26,
            bio: "Yoga instructor by day, food blogger by night. Obsessed with trying new restaurants and perfecting my homemade pasta recipe. Let's explore the city together! 🍝",
            occupation: "Yoga Instructor",
            education: "UC Berkeley",
            lookingFor: "New friends",
            distance: 2,
            imageURL: "https://picsum.photos/400/600?random=3",
            photos: [
                "https://picsum.photos/400/600?random=3",
                "https://picsum.photos/400/600?random=13",
                "https://picsum.photos/400/600?random=23"
            ],
            interests: ["Yoga", "Cooking", "Food", "Writing", "Meditation"]
        ),
        Profile(
            name: "Michael Johnson",
            age: 29,
            bio: "Tech entrepreneur building the next big thing. When I'm not coding, you'll find me at the gym or trying out new craft beer spots. Always learning something new! 🚀",
            occupation: "Software Engineer",
            education: "Stanford University",
            lookingFor: "Long-term relationship",
            distance: 5,
            imageURL: "https://picsum.photos/400/600?random=4",
            photos: [
                "https://picsum.photos/400/600?random=4",
                "https://picsum.photos/400/600?random=14",
                "https://picsum.photos/400/600?random=24"
            ],
            interests: ["Technology", "Fitness", "Craft Beer", "Innovation", "Gaming"]
        ),
        Profile(
            name: "Isabella Martinez",
            age: 25,
            bio: "Dance teacher who believes life is better with music. Love salsa nights, beach volleyball, and discovering hidden gems in the city. Let's dance! 💃",
            occupation: "Dance Instructor",
            education: "Juilliard School",
            lookingFor: "Fun dates",
            distance: 4,
            imageURL: "https://picsum.photos/400/600?random=5",
            photos: [
                "https://picsum.photos/400/600?random=5",
                "https://picsum.photos/400/600?random=15",
                "https://picsum.photos/400/600?random=25"
            ],
            interests: ["Dancing", "Music", "Beach Volleyball", "Nightlife", "Teaching"]
        ),
        Profile(
            name: "David Kim",
            age: 31,
            bio: "Marine biologist passionate about ocean conservation. Spend my weekends scuba diving and volunteering at the aquarium. Looking for someone who shares my love for nature! 🐠",
            occupation: "Marine Biologist",
            education: "UCLA",
            lookingFor: "Serious relationship",
            distance: 8,
            imageURL: "https://picsum.photos/400/600?random=6",
            photos: [
                "https://picsum.photos/400/600?random=6",
                "https://picsum.photos/400/600?random=16",
                "https://picsum.photos/400/600?random=26"
            ],
            interests: ["Marine Biology", "Scuba Diving", "Conservation", "Research", "Ocean"]
        )
    ]
}
