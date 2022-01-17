//
//  SettingsContentView.swift
//  Charger
//
//  Created by Rene B. Dena on 11/13/21.
//

import SwiftUI
import StoreKit
import MessageUI
import PurchaseKit

/// Shows the main settings for the app
struct SettingsContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var showLoadingView: Bool = false
    @Environment(\.presentationMode) var presentation
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            RadialGradient(gradient: AppConfig.backgroundGradient,
                           center: .top, startRadius: 50, endRadius: 350).ignoresSafeArea()

            /// Settings items
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    HeaderTitleView
                    CustomHeader(title: "PREMIUM VERSION")
                    InAppPurchasesPromoBannerView
                    InAppPurchasesView
                    CustomHeader(title: "HOW TO USE?")
                    TutorialItemView
                    CustomHeader(title: "FEEDBACK")
                    RatingShareView
                    CustomHeader(title: "SUPPORT")
                    PrivacySupportView
                }.padding([.leading, .trailing]).padding(5)
                Spacer(minLength: 40)
            })
            
            /// Close navigation button
            BarButtonsView
            
            /// Show loading view
            LoadingView(isLoading: $showLoadingView)
        }
    }
    
    /// Navigation Bar buttons
    private var BarButtonsView: some View {
        VStack {
            HStack {
                Spacer()
                CreateBarButton(icon: "xmark.circle") {
                    presentation.wrappedValue.dismiss()
                }
            }
            .padding([.leading, .trailing])
            Spacer()
        }
    }
    
    /// Header title view
    private var HeaderTitleView: some View {
        HStack {
            Text("Settings").bold().font(.largeTitle).foregroundColor(.white)
            Spacer()
        }.padding([.top, .bottom])
    }
    
    /// Create custom header view
    private func CustomHeader(title: String) -> some View {
        HStack {
            Text(title).font(.system(size: 18, weight: .medium))
            Spacer()
        }.foregroundColor(Color.white.opacity(0.7))
    }
    
    /// Custom settings item
    private func SettingsItem(title: String, icon: String, action: @escaping() -> Void) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator().impactOccurred()
            action()
        }, label: {
            HStack {
                Image(systemName: icon).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22, alignment: .center)
                Text(title).font(.system(size: 18))
                Spacer()
                Image(systemName: "chevron.right")
            }.foregroundColor(Color.white.opacity(0.7)).padding()
        })
    }
    
    // MARK: - In App Purchases
    private var InAppPurchasesView: some View {
        VStack {
            SettingsItem(title: "Upgrade to Premium", icon: "crown") {
                showLoadingView = true
                PKManager.purchaseProduct(identifier: AppConfig.premiumVersion) { _, status, _ in
                    DispatchQueue.main.async {
                        showLoadingView = false
                        if status == .success { manager.isPremium = true }
                    }
                }
            }
            Rectangle().frame(height: 1).foregroundColor(.white)
                .opacity(0.2).padding([.leading, .trailing])
            SettingsItem(title: "Restore Purchases", icon: "arrow.clockwise") {
                showLoadingView = true
                PKManager.restorePurchases { _, status, _ in
                    DispatchQueue.main.async {
                        showLoadingView = false
                        if status == .restored { manager.isPremium = true }
                    }
                }
            }
        }.padding([.top, .bottom], 5).background(
            AppConfig.backgroundDarkColor.opacity(0.51).cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    private var InAppPurchasesPromoBannerView: some View {
        ZStack {
            if manager.isPremium == false {
                ZStack {
                    LinearGradient(gradient: AppConfig.buttonGradient, startPoint: .topLeading, endPoint: .bottom)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Premium Version").bold().font(.system(size: 20))
                            Text("- Remove Ads").font(.system(size: 15)).opacity(0.7)
                            Text("- Unlock all Categories").font(.system(size: 15)).opacity(0.7)
                        }
                        Spacer()
                        Image(systemName: "crown").font(.system(size: 45))
                    }.foregroundColor(.white).padding([.leading, .trailing], 20)
                    
                    /// Decorative image
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "bolt.fill").font(.system(size: 120))
                                .foregroundColor(.white).opacity(0.1)
                                .offset(x: 10, y: -5).rotationEffect(.degrees(-10))
                        }
                    }
                }.frame(height: 110).cornerRadius(15).padding(.bottom, 5)
            }
        }
    }
    
    // MARK: - Rating and Share
    private var RatingShareView: some View {
        VStack {
            SettingsItem(title: "Rate App", icon: "star") {
                if let scene = UIApplication.shared.windows.first?.windowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            Rectangle().frame(height: 1).foregroundColor(.white)
                .opacity(0.2).padding([.leading, .trailing])
            SettingsItem(title: "Share App", icon: "square.and.arrow.up") {
                let shareController = UIActivityViewController(activityItems: [AppConfig.yourAppURL], applicationActivities: nil)
                RootViewController?.present(shareController, animated: true, completion: nil)
            }
        }.padding([.top, .bottom], 5).background(
            AppConfig.backgroundDarkColor.opacity(0.51).cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    // MARK: - Tutorial item
    private var TutorialItemView: some View {
        VStack {
            SettingsItem(title: "See Tutorial", icon: "questionmark.circle") {
                manager.fullScreen = .tutorial
            }
        }.padding([.top, .bottom], 5).background(
            AppConfig.backgroundDarkColor.opacity(0.51).cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    // MARK: - Site & Privacy
    private var PrivacySupportView: some View {
        VStack {
            SettingsItem(title: "Contact Me", icon: "envelope.badge") {
                EmailPresenter.shared.present()
            }
            
            Rectangle().frame(height: 1).foregroundColor(.white)
                .opacity(0.2).padding([.leading, .trailing])
            SettingsItem(title: "Other Apps", icon: "arrow.down.app") {
                UIApplication.shared.open(AppConfig.siteURL, options: [:], completionHandler: nil)
            }
            
            Rectangle().frame(height: 1).foregroundColor(.white)
                .opacity(0.2).padding([.leading, .trailing])
            SettingsItem(title: "Privacy Policy", icon: "hand.raised") {
                UIApplication.shared.open(AppConfig.privacyURL, options: [:], completionHandler: nil)
            }
            
        }.padding([.top, .bottom], 5).background(
            AppConfig.backgroundDarkColor.opacity(0.51).cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        )
    }
}

// MARK: - Preview UI
struct SettingsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContentView().environmentObject(DataManager())
    }
}

// MARK: - Mail presenter for SwiftUI
class EmailPresenter: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailPresenter()
    private override init() { }
    
    func present() {
        if !MFMailComposeViewController.canSendMail() {
            presentAlert(title: "Oops!", message: "Email feature is not supported on simulators or devices without the native iOS email app installed", primaryAction: .cancel)
            return
        }
        let picker = MFMailComposeViewController()
        picker.setToRecipients([AppConfig.emailSupport])
        picker.mailComposeDelegate = self
        RootViewController?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        RootViewController?.dismiss(animated: true, completion: nil)
    }
}

var RootViewController: UIViewController? {
    UIApplication.shared.windows.first?.rootViewController?.presentedViewController
}
