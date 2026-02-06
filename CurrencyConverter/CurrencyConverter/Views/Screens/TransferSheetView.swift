//
//  TransferSheetView.swift
//  BankApp
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI
import SwiftData

struct TransferSheetView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode

    // Access the ModelContext from the environment
    @Environment(\.modelContext) private var modelContext

    var mode: TransactionType

    @State private var amountString = ""
    @State private var selectedCurrency = "INR"
    @State private var showAlert = false
    @State private var alertMessage = ""

    let currencies = ["USD", "AED", "JPY", "CNY", "GBP", "CAD", "AUD", "IQD", "INR", "KRW"]


    // MARK: - Body
    var body: some View {
        ZStack {
            // Background color
            Color.darkBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                 // Balance Display
                VStack(alignment: .leading, spacing: 5) {
                    Text("Available Balance")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("₹ \(String(format: "%.2f", viewModel.balance))")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 20)

                // Currency Selector & Amount Input
                HStack(spacing: 12) {
                    // Currency dropdown menu
                    Menu {
                        ForEach(currencies, id: \.self) { currency in
                            Button(action: { selectedCurrency = currency }) {
                                HStack {
                                    Text(currency)
                                    if selectedCurrency == currency {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedCurrency).bold()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }

                    // Amount display field (read-only, updated by keypad)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)

                        Text(amountString.isEmpty ? "0.0" : amountString)
                            .foregroundColor(.black)
                            .font(.title3)
                            .bold()
                            .padding(.leading)
                    }
                    .frame(height: 55)
                }
                .padding(.horizontal)

                // Custom Keypad
                CustomKeypad(enteredValue: $amountString) {
                    Task {
                        await validateAndProcess()
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Amount"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .presentationDetents([.height(540)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(30)
    }

    // Helper Methods
    private func validateAndProcess() async {
        // Validate amount input
        guard let value = Double(amountString), value > 0 else {
            alertMessage = "Please enter a valid amount."
            showAlert = true
            return
        }

        // Fetch exchange rate and calculate INR equivalent
        let rate = await viewModel.getRate(for: selectedCurrency)
        let inrValue = value * rate

        // Check for sufficient funds on withdrawal
        if mode == .withdraw && inrValue > viewModel.balance {
            alertMessage = "You do not have enough balance for this transaction."
            showAlert = true
        } else {
            // Process transaction and dismiss sheet
            if mode == .deposit {
                viewModel.deposit(amount: value, currency: selectedCurrency, context: modelContext)
            } else {
                viewModel.withdraw(amount: value, currency: selectedCurrency, context: modelContext)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}
