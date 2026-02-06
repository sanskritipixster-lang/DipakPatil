//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by AressMacMiniA1993 on 06/02/26.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    @StateObject private var viewModel = AppViewModel()
    @State private var showSplash = true
    // Local Storage to store data in key-value pair
    @AppStorage("hasFinishedOnboarding") var hasFinishedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.lightBackground.edgesIgnoringSafeArea(.all)
                if showSplash {
                    Image(Constants.Images.splash)
                        .font(.system(size: 150))
                        .foregroundColor(.brandBlue)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showSplash = false }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                } else {
                    if hasFinishedOnboarding {
                        print("Home Screen")
                    } else {
                        OnboardingView(viewModel: viewModel)
                    }
                }
            }
        }
        .modelContainer(for: Transaction.self)
    }
}