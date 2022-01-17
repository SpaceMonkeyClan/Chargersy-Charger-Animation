//
//  AppConfig.swift
//  Charger
//
//  Created by Rene B. Dena on 11/11/21.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-4998868944035881/7360806695"
    static let adMobFrequency: Int = 3 /// every 3 theme views
    
    // MARK: - Site and Privacy
    static let siteURL: URL = URL(string: "https://space-monkey.online/")!
    static let privacyURL: URL = URL(string: "https://space-monkey.online/privacy-policy")!
    
    // MARK: - In App Purchases
    static let premiumVersion: String = "Charger.Premium"
    static let freeCategories: [String] = ["Top"]
    
    /// Your email for support
    static let emailSupport = "rene.b.dena@gmail.com"
    static let yourAppURL: URL = URL(string: "https://space-monkey.online/")!
    
    // MARK: - UI Configurations
    static let progressGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))])
    static let progressLineWidth: CGFloat = 15
    static let backgroundGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))])
    static let dashboardItemHeight: CGFloat = 250
    static let buttonGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))])
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
