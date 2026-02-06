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

    private let exchangeRates: [String: Double] = [
        "INR": 1.0,
        "USD": 83.39,
        "AED": 22.70,
        "JPY": 0.54,
        "CNY": 11.52,
        "GBP": 105.45,
        "CAD": 61.20,
        "AUD": 54.80,
        "IQD": 0.064,
        "KRW": 0.062
    ]

    func deposit(amount: Double, currency: String = "INR", context: ModelContext) {
        let inrValue = amount * getRate(for: currency)

        let newTransaction = Transaction(
            title: "ID\(UUID().uuidString.prefix(8).uppercased())",
            date: Date(),
            amount: amount,
            type: .deposit,
            currency: currency
        )

        withAnimation {
            // 4. Save to SwiftData persistent storage
            context.insert(newTransaction)
            print("Data deposited into database")
            balance += inrValue
        }
    }

    func withdraw(amount: Double, currency: String = "INR", context: ModelContext) {
        let inrValue = amount * getRate(for: currency)

        guard balance >= inrValue else { return }

        let newTransaction = Transaction(
            title: "ID\(UUID().uuidString.prefix(8).uppercased())",
            date: Date(),
            amount: amount,
            type: .withdraw,
            currency: currency
        )

        withAnimation {
            context.insert(newTransaction)
            print("Data widraw from the database")
            balance -= inrValue
        }
    }

    func getRate(for currency: String) -> Double {
        return exchangeRates[currency] ?? 1.0
    }
}
