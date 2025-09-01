//
//  DependencyContainer.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//

import Foundation

/// Central dependency injection container following SOLID principles
/// Updated to include SwipeUseCase for ProfileViewModel
@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Repositories
    
    private lazy var profileRepository: ProfileRepositoryProtocol = {
        ProfileRepository(
            remoteDataSource: RemoteDataSource(),
            localDataSource: LocalDataSource()
        )
    }()
    
    private lazy var swipeRepository: SwipeRepositoryProtocol = {
        SwipeRepository()
    }()
    
    // MARK: - Use Cases
    
    private lazy var profileUseCase: ProfileUseCaseProtocol = {
        ProfileUseCase(repository: profileRepository)
    }()
    
    private lazy var swipeUseCase: SwipeUseCaseProtocol = {
        SwipeUseCase(repository: swipeRepository)
    }()
    
    // MARK: - Manager Factory Methods
    
    /// Creates AppStateManager for UI state management
    func makeAppStateManager() -> AppStateManager {
        AppStateManager()
    }
    
    /// Creates ProfileViewModel with injected use cases (MVVM pattern)
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            profileUseCase: profileUseCase,
            swipeUseCase: swipeUseCase
        )
    }
}
