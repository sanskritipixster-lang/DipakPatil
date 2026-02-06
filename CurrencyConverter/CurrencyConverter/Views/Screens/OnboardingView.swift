//
//  OnboardingView.swift
//  CurrencyConverter
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: AppViewModel
    @AppStorage("hasFinishedOnboarding") var hasFinishedOnboarding: Bool = false

    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()

            // Welcome Header
            Text("Welcome to\nCurrency Convert!")
                .font(.system(size: 38))
                .bold()
                .multilineTextAlignment(.center)

            
            Spacer()

            // Illustration
            Image("Illustrator")
                .resizable()
                .scaledToFit()

            
            Spacer()

            // Feature Description
            Text("Instantly convert between over 150 currencies. Currency Convert is your one-stop solution for effortless curreny conversions.")
                .font(.headline)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 10)

            
            Spacer()

            // Get Started Button
            Button(action: {
                withAnimation { hasFinishedOnboarding = true }
            }) {
                Text("Get started")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandBlue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
}
