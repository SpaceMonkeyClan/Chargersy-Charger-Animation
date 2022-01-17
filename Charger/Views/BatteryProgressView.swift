//
//  BatteryProgressView.swift
//  Charger
//
//  Created by Rene B. Dena on 11/11/21.
//

import SwiftUI

/// Shows a circular battery progress view
struct BatteryProgressView: View {
    
    /// Battery percentage
    @State private var batteryLevel: Float = 0.0
    static let circleSize: CGFloat = UIScreen.main.bounds.width / 1.85
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.white, lineWidth: AppConfig.progressLineWidth/3)
                .frame(width: BatteryProgressView.circleSize - AppConfig.progressLineWidth * 2,
                       height: BatteryProgressView.circleSize - AppConfig.progressLineWidth * 2)
            
            /// Circular progress view
            ZStack {
                LinearGradient(gradient: AppConfig.progressGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .mask(
                        Circle().trim(from: 0.0, to: CGFloat(min(batteryLevel, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: AppConfig.progressLineWidth, lineCap: .round, lineJoin: .round)).foregroundColor(Color.red)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.easeIn(duration: AppConfig.dashboardCircleAnimationDuration).delay(1))
                            .padding(AppConfig.progressLineWidth + 3)
                    )
            }.frame(width: BatteryProgressView.circleSize, height: BatteryProgressView.circleSize)
            
            VStack {
                Image(systemName: "bolt.fill").font(.system(size: 35))
                Text("\(String(format: "%.0f", batteryLevel * 100))%")
                    .font(.system(size: 40)).bold()
            }.foregroundColor(.white)
        }
        
        /// Update progress view
        .onAppear(perform: {
            func updateBatteryStatusLevel() {
                batteryLevel = AppConfig.batteryPercentage
            }
            
            NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: nil, queue: nil) { (_) in
                updateBatteryStatusLevel()
            }
            
            NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: nil, queue: nil) { (_) in
                updateBatteryStatusLevel()
            }
            
            updateBatteryStatusLevel()
        })
    }
}

// MARK: - Preview UI
struct BatteryProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryProgressView()
    }
}
