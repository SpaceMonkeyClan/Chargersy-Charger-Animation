//
//  CategoryThemesContentView.swift
//  Charger
//
//  Created by Apps4World on 11/12/21.
//

import SwiftUI

/// Shows all category themes
struct CategoryThemesContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var showIntroAnimation: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            RadialGradient(gradient: AppConfig.backgroundGradient,
                           center: .top, startRadius: 50, endRadius: 350).ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 20)
                    if let categoryName = manager.seeAllCategoryThemes {
                        CategorySectionView(categoryName: categoryName,
                                            maxItemsCount: manager.themes(forCategory: categoryName).count,
                                            hideSeeAll: true)
                    }
                    Spacer(minLength: 200)
                }
            }
            BarButtonsView
        }
        .offset(y: showIntroAnimation ? 0 : UIScreen.main.bounds.height)
        .opacity(showIntroAnimation ? 1 : 0).onAppear {
            DispatchQueue.main.async {
                if showIntroAnimation == false {
                    withAnimation { showIntroAnimation = true }
                }
            }
        }
    }
    
    /// Navigation Bar buttons
    private var BarButtonsView: some View {
        VStack {
            HStack {
                Spacer()
                CreateBarButton(icon: "xmark.circle") {
                    if showIntroAnimation == true {
                        withAnimation { showIntroAnimation = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            manager.seeAllCategoryThemes = nil
                        }
                    }
                }
            }
            .padding([.leading, .trailing])
            Spacer()
        }
    }
}

// MARK: - Preview UI
struct CategoryThemesContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryThemesContentView().environmentObject(DataManager())
    }
}
