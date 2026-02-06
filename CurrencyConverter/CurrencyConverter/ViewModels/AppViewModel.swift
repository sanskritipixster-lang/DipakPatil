//
//  AppViewModel.swift
//  CurrencyConverter
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI
import Combine
import SwiftData

class AppViewModel: ObservableObject {
    @AppStorage("user_balance") var balance: Double = 0.0
    @Published var currentUser = User(name: "Alex Walker", greeting: "Good Morning 👋", image: "Profile")
    @Published var isLoading: Bool = false // Tracks API call state

    // Fallback rates if the API is unavailable
    private let exchangeRates: [String: Double] = [
        "INR": 1.0, "USD": 83.39, "AED": 22.70, "JPY": 0.54,
        "CNY": 11.52, "GBP": 105.45, "CAD": 61.20, "AUD": 54.80,
        "IQD": 0.064, "KRW": 0.062
    ]

    init() {
        
    }

    func deposit(amount: Double, currency: String = "INR", context: ModelContext) {
        Task {
            await updateRateAndProcess(amount: amount, currency: currency, type: .deposit, context: context)
        }
    }

    func withdraw(amount: Double, currency: String = "INR", context: ModelContext) {
        Task {
            await updateRateAndProcess(amount: amount, currency: currency, type: .withdraw, context: context)
        }
    }

    @MainActor
    private func updateRateAndProcess(amount: Double, currency: String, type: TransactionType, context: ModelContext) async {
        isLoading = true

        // Fetch live rate or fallback to static rate
        let rate: Double
        do {
            rate = try await CurrencyService.getConversionRate(from: currency)
        } catch {
            print("API Error, using fallback rate: \(error.localizedDescription)")
            rate = await getRate(for: currency)
        }

        // Calculate the INR equivalent using the fetched or fallback rate
        let inrValue = amount * rate
        isLoading = false

        // Validate withdrawal balance
        if type == .withdraw && balance < inrValue {
            print("Insufficient funds")
            return
        }

        // Create and save transaction
        let newTransaction = Transaction(
            title: "ID\(UUID().uuidString.prefix(8).uppercased())",
            date: Date(),
            amount: amount,
            type: type,
            currency: currency
        )

        withAnimation {
            context.insert(newTransaction)
            if type == .deposit {
                balance += inrValue
                print("Curreny (rate: \(rate), amount: \(amount)) = money deposited: \(inrValue) INR")
            } else {
                balance -= inrValue
                print("Curreny (rate: \(rate), amount: \(amount)) = money withdrawn: \(inrValue) INR")
            }
        }
    }

    func getRate(for currency: String) async -> Double {
        do {
            return try await CurrencyService.getConversionRate(from: currency)
        } catch {
            print("API Error, using fallback rate: \(error.localizedDescription)")
            return exchangeRates[currency] ?? 1.0
        }
    }
}
