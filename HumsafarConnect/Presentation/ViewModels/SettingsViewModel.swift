//
//  SettingsViewModel.swift
//  HumsafarConnect
//
//  Created by Raj Shekhar on 01/09/25.
//
import SwiftUI
import Combine
/// Settings view model
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var showingMyProfile = false
    @Published var showingPurchasePopup = false
    
    func showMyProfile() {
        showingMyProfile = true
    }
    
    func showPurchasePopup() {
        showingPurchasePopup = true
    }
}
