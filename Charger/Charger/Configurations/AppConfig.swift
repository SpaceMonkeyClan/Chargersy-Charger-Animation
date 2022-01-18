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
    static let adMobAdId: String = "ca-app-pub-4998868944035881/7360806695"
    static let adMobFrequency: Int = 3 /// every 3 theme views
    
    // MARK: - Terms and Privacy
    static let termsURL: URL = URL(string: "https://space-monkey.online/")!
    static let privacyURL: URL = URL(string: "https://space-monkey.online/privacy-policy")!
    static let contactURL: URL = URL(string: "https://space-monkey.online/contact")!

    
    // MARK: - In App Purchases
    static let premiumVersion: String = "Charger.Premium"
    static let freeCategories: [String] = ["Top"]
    
    /// Your email for support
    static let emailSupport = "rene.b.dena@gmail.com"
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/us/app/chargersy-charger-animation/id1605698211")!
    
    // MARK: - UI Configurations
    static let progressGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))])
    static let progressLineWidth: CGFloat = 15
    static let backgroundGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))])
    static let dashboardItemHeight: CGFloat = 250
    static let buttonGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))])
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
