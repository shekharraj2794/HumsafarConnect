
//
//  DesignSystem.swift
//  HumsafarConnect
//
//  Centralized Design System for Consistent UI
//  Created by Raj Shekhar on 01/09/25.
//

import SwiftUI

/// Centralized design system implementing consistent visual language
/// Ensures UI consistency and maintainability across the entire application
enum DesignSystem {
    
    // MARK: - Color Palette
    enum Colors {
        // Brand Colors - Core visual identity
        static let primary = Color.pink
        static let secondary = Color.purple
        static let accent = Color.blue
        
        // Semantic Colors - Meaning-based color assignments
        static let success = Color.green
        static let error = Color.red
        static let warning = Color.orange
        
        // Background Colors - Adapts automatically to light/dark mode
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        
        // Text Colors - Semantic naming for different content hierarchy
        static let text = Color.primary
        static let secondaryText = Color.secondary
    }
    
    // MARK: - Typography Scale
    /// Consistent typography hierarchy following iOS Human Interface Guidelines
    enum Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.medium)
        static let title3 = Font.title3
        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let subheadline = Font.subheadline
        static let caption = Font.caption
    }
    
    // MARK: - Spacing System
    /// 8-point grid system for consistent spacing throughout the app
    enum Spacing {
        static let xs: CGFloat = 4   // 0.5 units
        static let sm: CGFloat = 8   // 1 unit
        static let md: CGFloat = 16  // 2 units (base unit)
        static let lg: CGFloat = 24  // 3 units
        static let xl: CGFloat = 32  // 4 units
        static let xxl: CGFloat = 48 // 6 units
    }
    
    // MARK: - Border Radius
    /// Consistent corner radius values for UI elements
    enum CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }
    
    // MARK: - Shadow System
    /// Elevation-based shadow system for depth perception
    enum Shadow {
        static let light = (
            color: Color.black.opacity(0.1),
            radius: CGFloat(4),
            x: CGFloat(0),
            y: CGFloat(2)
        )
        static let medium = (
            color: Color.black.opacity(0.15),
            radius: CGFloat(8),
            x: CGFloat(0),
            y: CGFloat(4)
        )
        static let heavy = (
            color: Color.black.opacity(0.25),
            radius: CGFloat(16),
            x: CGFloat(0),
            y: CGFloat(8)
        )
    }
}
