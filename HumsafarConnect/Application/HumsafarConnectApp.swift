//
//  HumsafarConnectApp.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//

import SwiftUI

/// Main app entry point following dependency injection pattern
/// Implements Inversion of Control for clean architecture
@main
struct HumsafarConnectApp: App {
    /// Dependency container for managing app dependencies
    private let container = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container.makeAppStateManager())
                .environmentObject(container.makeProfileViewModel())
        }
    }
}
