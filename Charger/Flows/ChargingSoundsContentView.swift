//
//  ChargingSoundsContentView.swift
//  Charger
//
//  Created by Rene B. Dena on 11/12/21.
//

import SwiftUI
import AVFoundation

/// Shows a list of sounds
struct ChargingSoundsContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.presentationMode) var presentation
    @State private var isPlayingIndex: Int?
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            if let index = isPlayingIndex {
                PlayerView(videoFileName: "", audioFileName: "\(AppConfig.allSoundFileNames[index]).wav")
            }
            AppConfig.backgroundDarkColor.ignoresSafeArea()
            VStack {
                Text("Charging Sounds").font(.system(size: 22))
                    .bold().foregroundColor(.white).padding()
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<AppConfig.allSoundFileNames.count, id: \.self) { index in
                            VStack {
                                SoundItem(atIndex: index)
                                Color.white.frame(height: 1).opacity(0.1)
                            }.padding(.top).onTapGesture {
                                playStopSound(atIndex: index)
                            }
                        }
                        
                        /// Add No Sound options
                        NoSoundItemView.onTapGesture {
                            DispatchQueue.main.async {
                                isPlayingIndex = nil
                                NotificationCenter.default.post(name: Notification.Name("stopPlayer"), object: nil)
                                manager.soundFileName = " "
                            }
                        }
                    }
                }
            }.padding([.leading, .trailing])
        }
    }
    
    private func SoundItem(atIndex index: Int) -> some View {
        NotificationCenter.default.addObserver(forName: Notification.Name("didFinishPlaying"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                isPlayingIndex = nil
            }
        }
        let isPlaying = isPlayingIndex == index
        return HStack {
            Image(systemName: "\(isPlaying ? "pause" : "play").circle\(isPlaying ? ".fill" : "")")
            Text(AppConfig.allSoundFileNames[index].capitalized)
            Spacer()
            if manager.soundFileName == "\(AppConfig.allSoundFileNames[index]).wav" || isPlaying {
                Image(systemName: "checkmark.circle.fill")
            }
        }
        .foregroundColor(.white)
        .font(.system(size: 22, weight: .semibold))
    }
    
    private func playStopSound(atIndex index: Int) {
        DispatchQueue.main.async {
            isPlayingIndex = nil
            NotificationCenter.default.post(name: Notification.Name("stopPlayer"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + (isPlayingIndex != nil ? 1 : 0)) {
                isPlayingIndex = index
                manager.soundFileName = "\(AppConfig.allSoundFileNames[index]).wav"
            }
        }
    }
    
    private var NoSoundItemView: some View {
        HStack {
            Image(systemName: "speaker.slash.fill")
            Text("Disable Sound")
            Spacer()
            if manager.soundFileName == " " {
                Image(systemName: "checkmark.circle.fill")
            }
        }
        .foregroundColor(.white)
        .font(.system(size: 22, weight: .semibold))
        .padding(.top, 20)
    }
}

// MARK: - Preview UI
struct ChargingSoundsContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChargingSoundsContentView().environmentObject(DataManager())
    }
}
