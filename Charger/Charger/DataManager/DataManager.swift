//
//  DataManager.swift
//  Charger
//
//  Created by Apps4World on 11/11/21.
//

import SwiftUI
import Foundation

/// Main data manager handling application state
class DataManager: NSObject, ObservableObject {
    /// Dynamic properties that the UI will react to
    @Published var themes: [ChargerTheme] = [ChargerTheme]()
    @Published var fullScreen: FullScreenType?
    @Published var showThemeSettings: Bool = false
    @Published var seeAllCategoryThemes: String?
    
    @Published var themePreview: ChargerTheme? {
        didSet { fullScreen = .themePreview }
    }
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("isPremium") var isPremium: Bool = false
    @AppStorage("didShowTutorial") var didShowTutorial: Bool = false
    @AppStorage("chargingIconName") var chargingIconName: String = ""
    @AppStorage("selectedThemeId") var selectedThemeId: String = ""
    @AppStorage("soundFileName") var soundFileName: String = ""
    
    /// All progress/charging icons
    var chargingIcons: [UIImage] = [UIImage]()
    
    /// Default init method
    override init() {
        super.init()
        fetchThemes()
        loadIcons()
    }
    
    private func fetchThemes() {
        guard let path = Bundle.main.path(forResource: "ChargerThemes", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let models = try? JSONDecoder().decode([ChargerTheme].self, from: data)
        else { return }
        themes = models
    }
    
    private func loadIcons() {
        for index in 1..<INT_MAX {
            let iconName = "bolt\(index)"
            if let icon = UIImage(named: iconName) {
                icon.accessibilityIdentifier = iconName
                chargingIcons.append(icon)
            } else { break }
        }
    }
}

// MARK: - Configure Category themes
extension DataManager {
    /// Returns all themes for a category name
    func themes(forCategory category: String) -> [ChargerTheme] {
        themes.filter({ $0.categoryName == category })
    }
    
    /// Returns the icon on the left side of the category name header
    func icon(forCategory category: String) -> String {
        themes(forCategory: category)[0].categoryIcon
    }
    
    /// The thumbnail for a given animation theme
    func thumbnail(forTheme theme: ChargerTheme) -> UIImage {
        themes.filter({ $0.id == theme.id })[0].thumbnail
    }
    
    /// Progress icon file name for a given animation theme
    func progressIcon(forTheme theme: ChargerTheme) -> UIImage? {
        let themeIconId = themes.filter({ $0.id == theme.id })[0].progressIconName
        var iconId = chargingIconName.isEmpty ? themeIconId : chargingIconName
        iconId = iconId.replacingOccurrences(of: ".png", with: "")
        DispatchQueue.main.async {
            if self.chargingIconName.isEmpty { self.chargingIconName = iconId }
        }
        return chargingIcons.first(where: { $0.accessibilityIdentifier == iconId })
    }
    
    /// All unique categories and setting the `Top` category name at the top of the list
    var allCategories: [String] {
        var categories = [String]()
        themes.forEach { theme in
            if !categories.contains(theme.categoryName) {
                categories.append(theme.categoryName)
            }
        }
        categories.removeAll(where: { $0 == "Top" })
        categories.insert("Top", at: 0)
        return categories
    }
}

// MARK: - Set Charging Theme animation
extension DataManager {
    /// Save the charging theme and ask the user if they want to see a tutorial
    func setChargingAnimation(exit: @escaping() -> Void) {
        func saveSelectedTheme() {
            showThemeSettings = false
            selectedThemeId = themePreview?.id ?? ""
        }
        
        if didShowTutorial == false && UIDevice.current.batteryState != .charging {
            presentAlert(title: "See Tutorial", message: "Would you like to see a tutorial on how to use this app?", primaryAction: UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                saveSelectedTheme()
            }), secondaryAction: UIAlertAction(title: "Yes, Please", style: .default, handler: { _ in
                saveSelectedTheme()
                self.fullScreen = .tutorial
                self.didShowTutorial = true
            }))
        } else {
            saveSelectedTheme()
            exit()
        }
    }
    
    /// Get the saved charging theme and only return it if the device is charging
    var savedChargingTheme: ChargerTheme? {
        guard let theme = themes.first(where: { $0.id == selectedThemeId }) else { return nil }
        let isCharging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
        if isCharging {
            /// Add a notification to check the device is disconnect, so we can close the app
            NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: nil, queue: nil) { (_) in
                fatalError()
            }
        }
        return isCharging ? theme : nil
    }
}
