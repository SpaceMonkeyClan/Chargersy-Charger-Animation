//
//  TutorialContentView.swift
//  Charger
//
//  Created by Rene B. Dena on 11/13/21.
//

import SwiftUI

// MARK: - Tutorial Step
struct TutorialStep {
    let title: String
    let subtitle: String?
}

let steps: [TutorialStep] = [
    .init(title: "Open 'Shortcuts' app", subtitle: "If you can not find it, please download it from the App Store"),
    .init(title: "Select 'Automation' tab", subtitle: "Then tap 'Create Personal Automation' button"),
    .init(title: "Select 'Charger' option", subtitle: "Scroll to the bottom and select the charger option"),
    .init(title: "Is Connected", subtitle: "Select 'Is Connected' option then tap 'Next' on the top corner"),
    .init(title: "Open app", subtitle: "Select the 'Open app' option, or tap 'Add Action' then select 'Open app'"),
    .init(title: "Select an app", subtitle: "Tap the 'app' item next to 'Open', then search and select this app"),
    .init(title: "Ask Before Running", subtitle: "Make sure to Turn Off the 'Ask Before Running' option, then tap 'Done'")
]

/// Show app tutorial flow
struct TutorialContentView: View {
    
    @Environment(\.presentationMode) var presentation
    @State private var selectedIndex: Int = 0
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            RadialGradient(gradient: AppConfig.backgroundGradient,
                           center: .top, startRadius: 50, endRadius: 350).ignoresSafeArea()

            /// Tutorial items
            VStack(spacing: 0) {
                HeaderTitleView.padding([.leading, .trailing])
                TabView(selection: $selectedIndex) {
                    ForEach(0..<steps.count, id: \.self) { step in
                        TutorialStepView(atIndex: step)
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack {
                    ForEach(0..<steps.count, id: \.self) { dot in
                        Circle().frame(width: 10, height: 10)
                            .foregroundColor(.white)
                            .opacity(dot == selectedIndex ? 1 : 0.3)
                    }
                }.padding(.top, 20)
                Spacer()
            }
            
            /// Close navigation button
            BarButtonsView
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
            Text("Tutorial").bold().font(.largeTitle).foregroundColor(.white)
            Spacer()
        }.padding([.top, .bottom])
    }
    
    private func TutorialStepView(atIndex index: Int) -> some View {
        VStack(spacing: 20) {
            VStack {
                Capsule().frame(width: 50, height: 2)
                VStack(alignment: .center) {
                    Text(steps[index].title).font(.system(size: 22)).bold()
                    Text(steps[index].subtitle ?? " ").opacity(0.7)
                }
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
            }.foregroundColor(.white)
            Image("step\(index)")
                .resizable().aspectRatio(contentMode: .fit)
        }.padding([.leading, .trailing])
    }
}

// MARK: - Preview UI
struct TutorialContentView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialContentView()
    }
}
