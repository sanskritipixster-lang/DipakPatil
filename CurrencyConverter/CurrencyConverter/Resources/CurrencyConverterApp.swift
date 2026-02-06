//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by AressMacMiniA1993 on 06/02/26.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    // MARK: - Properties
    @StateObject private var viewModel = AppViewModel()
    @State private var showSplash = true
    @AppStorage("hasFinishedOnboarding") var hasFinishedOnboarding: Bool = false

    init() {
        KeychainHelper.save("8cea16c76b5c2669eae114d1")
    }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Background color for the entire app
                Color.lightBackground.edgesIgnoringSafeArea(.all)
                
                if showSplash {
                    // Splash screen with 2-second delay
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
                    // Navigation: Show onboarding or home based on completion status
                    if hasFinishedOnboarding {
                        HomeView(viewModel: viewModel)
                    } else {
                        OnboardingView(viewModel: viewModel)
                    }
                }
            }
        }
        // SwiftData model container for Transaction persistence
        .modelContainer(for: Transaction.self)
    }
}