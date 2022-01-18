//
//  CategorySectionView.swift
//  Charger
//
//  Created by Apps4World on 11/12/21.
//

import SwiftUI

/// Shows a category of animations
struct CategorySectionView: View {
    
    @EnvironmentObject var manager: DataManager
    @State var categoryName: String
    @State var maxItemsCount: Int = 2
    @State var hideSeeAll: Bool = false
    private let grid = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            CategoryNameHeaderView
            ZStack {
                if !manager.isPremium && !AppConfig.freeCategories.contains(categoryName) {
                    Color.black.cornerRadius(20)
                }
                
                LazyVGrid(columns: grid, spacing: 20, content: {
                    ForEach(0..<min(CategoryThemes.count, maxItemsCount), id: \.self, content: { index in
                        Button(action: {
                            manager.themePreview = CategoryThemes[index]
                        }) {
                            ThemeItem(atIndex: index)
                        }
                    })
                }).disabled(!manager.isPremium && !AppConfig.freeCategories.contains(categoryName))
                
                /// Show premium overlay
                if !manager.isPremium && !AppConfig.freeCategories.contains(categoryName) {
                    ZStack {
                        Color.black.cornerRadius(20).opacity(0.5)
                        Image(systemName: "lock.fill").font(.system(size: 65)).foregroundColor(.white)
                    }.onTapGesture {
                        presentAlert(title: "Premium Content", message: "You have to upgrade to the premium version to unlock all features", primaryAction: .cancel)
                    }
                }
            }
        }.padding([.leading, .trailing])
    }
    
    private func ThemeItem(atIndex index: Int) -> some View {
        Image(uiImage: manager.thumbnail(forTheme: CategoryThemes[index]))
            .resizable().aspectRatio(contentMode: .fill)
            .frame(height: AppConfig.dashboardItemHeight)
            .contentShape(Rectangle()).cornerRadius(10)
            .shadow(color: Color.white.opacity(0.1), radius: 10)
    }
    
    private var CategoryNameHeaderView: some View {
        HStack {
            HStack(spacing: 5) {
                Text(manager.icon(forCategory: categoryName))
                Text(categoryName).bold()
            }.font(.system(size: 26))
            Spacer()
            if hideSeeAll == false {
                Button("See All") {
                    manager.seeAllCategoryThemes = categoryName
                }
                .font(.system(size: 15, weight: .medium))
                .disabled(!manager.isPremium && !AppConfig.freeCategories.contains(categoryName))
                .opacity(!manager.isPremium && !AppConfig.freeCategories.contains(categoryName) ? 0 : 1)
            }
        }.foregroundColor(.white)
    }
    
    private var CategoryThemes: [ChargerTheme] {
        manager.themes(forCategory: categoryName)
    }
}

// MARK: - Preview UI
struct CategorySectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            CategorySectionView(categoryName: "Top")
                .environmentObject(DataManager())
        }
    }
}
