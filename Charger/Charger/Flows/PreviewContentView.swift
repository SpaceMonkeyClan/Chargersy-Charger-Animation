//
//  PreviewContentView.swift
//  Charger
//
//  Created by Apps4World on 11/12/21.
//

import AVKit
import SwiftUI

/// Preview tools sheet type
enum ModalSheetType: Identifiable {
    case icons, sounds
    var id: Int { hashValue }
}

/// Main view to preview a charging animation theme
struct PreviewContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.presentationMode) var presentation
    @State private var batteryLevel: Float = 0.0
    @State private var modalSheetType: ModalSheetType?
    @State private var didShowAds: Bool = false
    private let screen: CGRect = UIScreen.main.bounds
    
    // MARK: - Main rendering function
    var body: some View {
        GeometryReader { _ in
            Color.black.ignoresSafeArea()
            
            ZStack {
                if let theme = manager.themePreview {
                    Image(uiImage: manager.thumbnail(forTheme: theme)).resizable()
                        .aspectRatio(contentMode: .fill)
                    PlayerView(videoFileName: theme.animationFileName,
                               audioFileName: manager.soundFileName.isEmpty ? theme.soundFileName : manager.soundFileName)
                }
                
                /// Tap area to toggle configurations view
                Color.black.frame(width: screen.width/1.2, height: screen.height/1.4)
                    .opacity(0.0001).onTapGesture {
                        if manager.savedChargingTheme == nil {
                            manager.showThemeSettings.toggle()
                        } else {
                            presentAlert(title: "Charging", message: "You can not use the app while plugged in", primaryAction: .cancel)
                        }
                    }
            }
            .frame(width: screen.width, height: screen.height)
            .ignoresSafeArea()
            
            /// Top navigation bar buttons
            BarButtonsView
            
            /// Bottom configurations view
            ThemeConfigurationView
            
            /// Bolt icon overlay at the top of the screen
            BoltIconOverlay
            
            /// Charging level text
            ChargingLevelText
        }
        
        /// Present a modal sheet flow
        .sheet(item: $modalSheetType) { type in
            switch type {
            case .icons:
                ChargingIconsContentView().environmentObject(manager)
            case .sounds:
                ChargingSoundsContentView().environmentObject(manager)
            }
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
            
            /// Show ads only when the phone is not charging
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if didShowAds == false && manager.savedChargingTheme == nil && manager.isPremium == false {
                    didShowAds = true
                    Interstitial.shared.showInterstitialAds()
                }
            }
        })
    }
    
    /// Navigation Bar buttons
    private var BarButtonsView: some View {
        VStack {
            HStack {
                Spacer()
                CreateBarButton(icon: "xmark.circle") {
                    exitPreview()
                }
            }.padding([.leading, .trailing])
            Spacer()
        }
        .opacity(manager.showThemeSettings ? 1: 0)
        .animation(.easeIn)
    }
    
    /// Theme configurations
    private var ThemeConfigurationView: some View {
        VStack {
            Spacer()
            VStack {
                Text("Configurations").foregroundColor(.black)
                    .font(.system(size: 22)).bold()
                Color.black.frame(height: 1).opacity(0.1)
                CreateConfigurationItem(icon: "bolt.fill", text: "Charging Icon") {
                    modalSheetType = .icons
                }
                Color.black.frame(height: 1).opacity(0.1)
                CreateConfigurationItem(icon: "music.quarternote.3", text: "Charging Sound") {
                    modalSheetType = .sounds
                }
                Color.black.frame(height: 1).opacity(0.1)
                Button(action: {
                    manager.setChargingAnimation() {
                        exitPreview()
                    }
                }) {
                    ZStack {
                        LinearGradient(gradient: AppConfig.buttonGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                            .cornerRadius(20)
                        Text("Set Animation")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .bold()
                    }
                }.frame(height: 60).padding(.top)
            }.padding(20).padding(.top, 5).background(
                RoundedCorner(radius: 40, corners: [.topLeft, .topRight])
                    .ignoresSafeArea().foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, y: -10)
            )
        }
        .offset(y: manager.showThemeSettings ? 0 : screen.height/2)
        .animation(.easeIn)
    }
    
    private func CreateConfigurationItem(icon: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon).frame(width: 40)
                Text(text)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .contentShape(Rectangle())
            .foregroundColor(.black).opacity(0.8)
            .font(.system(size: 20, weight: .semibold))
            .padding([.top, .bottom], 10)
        }
    }
    
    /// Bolt Icon overlay
    private var BoltIconOverlay: some View {
        VStack {
            HStack {
                Spacer()
                if let theme = manager.themePreview, let image = manager.progressIcon(forTheme: theme) {
                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: AppConfig.boltIconSize, height: AppConfig.boltIconSize, alignment: .center)
                }
                Spacer()
            }.padding()
            
            Spacer()
        }
    }
    
    /// Charging level
    private var ChargingLevelText: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("\(String(format: "%.0f", batteryLevel * 100))%")
                    .font(.system(size: 35)).bold().foregroundColor(.white)
                Spacer()
            }
            Spacer()
        }
    }
    
    private func exitPreview() {
        manager.showThemeSettings = false
        NotificationCenter.default.post(name: Notification.Name("stopPlayer"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            presentation.wrappedValue.dismiss()
        }
    }
}

// MARK: - Preview UI
struct PreviewContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.themePreview = manager.themes[0]
        return PreviewContentView().environmentObject(manager)
    }
}

// MARK: - Custom video player
struct PlayerView: UIViewRepresentable {
    @State var videoFileName: String
    @State var audioFileName: String
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) { }
    func makeUIView(context: Context) -> UIView {
        return AudioVideoPlayerView(frame: .zero, videoFileName: videoFileName, audioFileName: audioFileName)
    }
}

class AudioVideoPlayerView: UIView, AVAudioPlayerDelegate {
    
    private var playerLayer: AVPlayerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var player: AVAudioPlayer?
    
    static var shared: AudioVideoPlayerView = AudioVideoPlayerView()
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    convenience init() {
        self.init()
    }
    
    init(frame: CGRect, videoFileName: String, audioFileName: String) {
        super.init(frame: frame)
        playSound(audioFileName: audioFileName)
        guard let url = Bundle.main.url(forResource: videoFileName, withExtension: nil) else { return }
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer()
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        playerLayer.player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    private func playSound(audioFileName: String) {
        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: nil) else { return }
        NotificationCenter.default.addObserver(forName: Notification.Name("stopPlayer"), object: nil, queue: nil) { _ in
            self.player?.stop()
            self.player = nil
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player?.delegate = self
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        NotificationCenter.default.post(name: Notification.Name("didFinishPlaying"), object: nil)
    }
}
