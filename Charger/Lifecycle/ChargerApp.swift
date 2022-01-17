//
//  ChargerApp.swift
//  Charger
//
//  Created by Rene B. Dena on 11/11/21.
//

import SwiftUI
import PurchaseKit
import GoogleMobileAds

@main
struct ChargerApp: App {
    
    @StateObject private var manager: DataManager = DataManager()
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        PKManager.loadProducts(identifiers: [AppConfig.premiumVersion])
    }
    
    // MARK: - Main rendering function
    var body: some Scene {
        WindowGroup {
            if let savedTheme = manager.savedChargingTheme {
                ChargingThemePreview(withTheme: savedTheme)
            } else {
                DashboardContentView().environmentObject(manager)
            }
        }
    }
    
    /// Theme Preview while charging
    private func ChargingThemePreview(withTheme theme: ChargerTheme) -> some View {
        DispatchQueue.main.async {
            manager.themePreview = theme
        }
        return PreviewContentView().environmentObject(manager)
    }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction, secondaryAction: UIAlertAction? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(primaryAction)
    if let secondary = secondaryAction { alert.addAction(secondary) }
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    root?.present(alert, animated: true, completion: nil)
}

// MARK: - Custom UIAlertAction items
extension UIAlertAction {
    static var cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}

/// Show a loading indicator view
struct LoadingView: View {
    
    @Binding var isLoading: Bool
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            if isLoading {
                Color.black.edgesIgnoringSafeArea(.all).opacity(0.4)
                ProgressView("Please Wait...")
                    .scaleEffect(1.1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white).padding()
                    .background(RoundedRectangle(cornerRadius: 10).opacity(0.7))
            }
        }.colorScheme(.light)
    }
}

// MARK: - Google AdMob Interstitial - Support class
class Interstitial: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    private var presentedCount: Int = 0
    
    static var shared: Interstitial = Interstitial()
    
    /// Request AdMob Interstitial ads
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppConfig.adMobAdId, request: request, completionHandler: { [self] ad, error in
            if ad != nil { interstitial = ad }
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func showInterstitialAds() {
        presentedCount += 1
        if self.interstitial != nil, presentedCount % AppConfig.adMobFrequency == 0 {
            var root = UIApplication.shared.windows.first?.rootViewController
            if let presenter = root?.presentedViewController { root = presenter }
            self.interstitial?.present(fromRootViewController: root!)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
}
