//
//  DashboardContentView.swift
//  Charger
//
//  Created by Rene B. Dena on 11/11/21.
//

import SwiftUI

/// App full screen type
enum FullScreenType: Identifiable {
    case themePreview, settings, tutorial
    var id: Int { hashValue }
}

/// Main dashboard of the app
struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            RadialGradient(gradient: AppConfig.backgroundGradient,
                           center: .top, startRadius: 50, endRadius: 350).ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 20)
                    BatteryProgressView()
                    CategoriesList
                    Spacer(minLength: 40)
                }
            }
                        
            BarButtonsView
            
            /// Show `See all` items as an overlay
            if manager.seeAllCategoryThemes != nil {
                CategoryThemesContentView().environmentObject(manager)
            }
        }
        
        /// Full screen flow presentation
        .fullScreenCover(item: $manager.fullScreen) { type in
            switch type {
            case .themePreview:
                PreviewContentView().environmentObject(manager)
            case .settings:
                SettingsContentView().environmentObject(manager)
            case .tutorial:
                TutorialContentView()
            }
        }
        
        /// Load ads when the view appears
        .onAppear {
            if manager.isPremium == false {
                Interstitial.shared.loadInterstitial()
            }
        }
    }
    
    /// Categories list
    private var CategoriesList: some View {
        VStack(spacing: 50) {
            ForEach(0..<manager.allCategories.count, id: \.self) { index in
                CategorySectionView(categoryName: manager.allCategories[index])
            }
        }
    }
    
    /// Navigation Bar buttons
    private var BarButtonsView: some View {
        VStack {
            HStack {
                Spacer()
                CreateBarButton(icon: "gearshape.fill") {
                    manager.fullScreen = .settings
                }
            }.padding([.leading, .trailing])
            Spacer()
        }
    }
}

// MARK: - Preview UI
struct DashboardPreview: PreviewProvider {
    static var previews: some View {
        DashboardContentView().environmentObject(DataManager())
    }
}

func CreateBarButton(icon: String, action: @escaping () -> Void) -> some View {
    Button(action: action, label: {
        Image(systemName: icon).font(.system(size: 25)).foregroundColor(.white)
            .contentShape(Rectangle()).frame(width: 45, height: 45, alignment: .center)
            .padding(-10).padding(.top, 5)
    })
}
