//
//  LocalDataSource.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//


import Foundation

/// Local data source for caching and persistence operations
/// Thread-safe implementation using actor for concurrent access
actor LocalDataSource: LocalDataSourceProtocol {
    private var cachedProfiles: [Profile] = []
    private var swipeHistory: [SwipeAction] = []
    
    func cacheProfiles(_ profiles: [Profile]) async {
        cachedProfiles = profiles
        // In production: persist to Core Data, SQLite, or UserDefaults
    }
    
    func getCachedProfiles() async -> [Profile] {
        return cachedProfiles
    }
    
    func saveSwipeAction(_ swipeAction: SwipeAction) async {
        swipeHistory.append(swipeAction)
        // In production: persist to Core Data or SQLite for permanent storage
    }
    
    /// Retrieves swipe history for analytics (not used in current UI but available)
    func getSwipeHistory() async -> [SwipeAction] {
        return swipeHistory
    }
}

// MARK: - Production Implementation Reference
/*
 In production with Core Data, this would look like:
 
 actor LocalDataSource: LocalDataSourceProtocol {
     private let persistentContainer: NSPersistentContainer
     
     init(persistentContainer: NSPersistentContainer = CoreDataStack.shared.container) {
         self.persistentContainer = persistentContainer
     }
     
     func cacheProfiles(_ profiles: [Profile]) async {
         let context = persistentContainer.newBackgroundContext()
         
         await context.perform {
             // Clear existing cached profiles
             let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProfileEntity.fetchRequest()
             let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
             try? context.execute(deleteRequest)
             
             // Insert new profiles
             for profile in profiles {
                 let profileEntity = ProfileEntity(context: context)
                 profileEntity.configure(with: profile)
             }
             
             try? context.save()
         }
     }
     
     func getCachedProfiles() async -> [Profile] {
         let context = persistentContainer.viewContext
         
         return await context.perform {
             let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
             let profileEntities = try? context.fetch(fetchRequest)
             return profileEntities?.map { $0.toDomain() } ?? []
         }
     }
     
     func saveSwipeAction(_ swipeAction: SwipeAction) async {
         let context = persistentContainer.newBackgroundContext()
         
         await context.perform {
             let swipeEntity = SwipeActionEntity(context: context)
             swipeEntity.configure(with: swipeAction)
             try? context.save()
         }
     }
 }
*/
