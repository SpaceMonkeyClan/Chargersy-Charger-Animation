//
//  ChargerTheme.swift
//  Charger
//
//  Created by Rene B. Dena on 11/11/21.
//

import SwiftUI
import Foundation

/// Represents a charger animation theme
struct ChargerTheme: Codable {
    let id: String
    let categoryIcon: String
    let categoryName: String
    let soundFileName: String
    let animationFileName: String
    let progressIconName: String
    
    /// Computed properties
    var thumbnail: UIImage {
        UIImage(named: animationFileName.replacingOccurrences(of: ".mp4", with: ".png")) ?? UIImage()
    }
}
