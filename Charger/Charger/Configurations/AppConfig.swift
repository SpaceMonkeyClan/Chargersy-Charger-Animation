//
//  AppConfig.swift
//  Charger
//
//  Created by Apps4World on 11/11/21.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-3940256099942544/4411468910"
    static let adMobFrequency: Int = 3 /// every 3 theme views
    
    // MARK: - Terms and Privacy
    static let termsURL: URL = URL(string: "https://apps4world.com")!
    static let privacyURL: URL = URL(string: "https://apps4world.com")!
    
    // MARK: - In App Purchases
    static let premiumVersion: String = "Charger.Premium"
    static let freeCategories: [String] = ["Top"]
    
    /// Your email for support
    static let emailSupport = "support@apps4world.com"
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/us/app/apple-store/id375380948")!
    
    // MARK: - UI Configurations
    static let progressGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))])
    static let progressLineWidth: CGFloat = 15
    static let backgroundGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.2196078431, green: 0.2588235294, blue: 0.7294117647, alpha: 1)), Color(#colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.2274509804, alpha: 1))])
    static let dashboardItemHeight: CGFloat = 250
    static let buttonGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.2518373728, green: 0.2469416559, blue: 0.6877331734, alpha: 1)), Color(#colorLiteral(red: 0.7147428393, green: 0.2732455134, blue: 0.7767350078, alpha: 1))])
    static let boltIconSize: CGFloat = 50
    static let backgroundDarkColor: Color = Color(#colorLiteral(red: 0.1326494813, green: 0.1326494813, blue: 0.1326494813, alpha: 1))
    static let dashboardCircleAnimationDuration: Double = 0.7
    
    /// Define all sound files here
    static let allSoundFileNames: [String] = [
        "electric static", "electric whoosh", "happy bells", "scanning alarm",
        "signal alert", "slot machine alarm", "sport start"
    ]
    
    // MARK: - Battery Level
    static var batteryPercentage: Float {
        if UIDevice.current.batteryLevel < 0 {
            return 0.0 /// You can set this to anything from 0.0 to 1.0 when running on simulator for testing purposes only
        }
        return UIDevice.current.batteryLevel
    }
}
