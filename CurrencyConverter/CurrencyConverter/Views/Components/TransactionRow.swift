//
//  TransactionRow.swift
//  BankApp
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI

struct TransactionRow: View {
    @ObservedObject var viewModel: AppViewModel
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 15) {
            // Icon Section
            ZStack {
                Circle()
                    .fill(transaction.type == .deposit ? Color.green : Color.red)
                    .opacity(0.1)
                Image(transaction.type == .deposit ? "deposit" : "withdraw")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(transaction.type == .deposit ? .green : .red)
            }
            .frame(width: 44, height: 44)

            // Info Section
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 16, weight: .bold))
                Text(formatDate(transaction.date))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Amount Section
            VStack(alignment: .trailing, spacing: 4) {
                if transaction.currency == "₹" || transaction.currency == "INR" {
                    Text("INR \(String(format: "%.0f", transaction.amount))")
                        .font(.system(size: 18, weight: .bold))
                } else {
                    Text("\(transaction.currency) \(String(format: "%.0f", transaction.amount))")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 10))
                            .foregroundColor(.gray.opacity(0.6))

                        // Using the ViewModel helper for accurate display
                        Text("₹ \(String(format: "%.2f", transaction.amount * viewModel.getRate(for: transaction.currency)))")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter.string(from: date)
    }
}
