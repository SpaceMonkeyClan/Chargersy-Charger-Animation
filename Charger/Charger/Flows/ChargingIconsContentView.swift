//
//  ChargingIconsContentView.swift
//  Charger
//
//  Created by Apps4World on 11/12/21.
//

import SwiftUI

/// Shows a grid of charging icons
struct ChargingIconsContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.presentationMode) var presentation
    private let screen: CGRect = UIScreen.main.bounds
    private let grid = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            AppConfig.backgroundDarkColor.ignoresSafeArea()
            VStack {
                Text("Charging Icons").font(.system(size: 22))
                    .bold().foregroundColor(.white).padding()
                ScrollView {
                    LazyVGrid(columns: grid, spacing: 20, content: {
                        ForEach(0..<manager.chargingIcons.count, id: \.self, content: { index in
                            Button {
                                if let itemId = manager.chargingIcons[index].accessibilityIdentifier {
                                    manager.chargingIconName = manager.chargingIconName == itemId ? "" : itemId
                                }
                                presentation.wrappedValue.dismiss()
                            } label: {
                                ChargingIcon(atIndex: index)
                            }
                        })
                    })
                }
            }.padding([.leading, .trailing])
        }
    }
    
    /// Charging icon item
    private func ChargingIcon(atIndex index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.white, lineWidth: 4)
                .padding(5)
                .frame(width: screen.width/3 - 20, height: screen.width/3 - 20)
                .opacity(
                    manager.chargingIcons[index].accessibilityIdentifier == manager.chargingIconName ? 1 : 0
                )
            Image(uiImage: manager.chargingIcons[index])
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: screen.width/3 - 50, height: screen.width/3 - 50)
        }
    }
}

// MARK: - Preview UI
struct ChargingIconsContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChargingIconsContentView().environmentObject(DataManager())
    }
}
