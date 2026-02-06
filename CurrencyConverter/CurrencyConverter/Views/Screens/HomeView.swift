//
//  HomeView.swift
//  BankApp
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {

    // MARK: - Properties
    @ObservedObject var viewModel: AppViewModel
    // Context of SwiftData DB
    @Environment(\.modelContext) private var modelContext
    // Fetch data from SwiftData DB using Query handler
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]

    @State private var showDeposit = false
    @State private var showWithdraw = false
    @State private var isExpanded = false

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            // Top gradient background
            Color.brandBlue.ignoresSafeArea(edges: .top)
            
            VStack(spacing: 0) {
                HStack {
                    // User profile image
                    Image(viewModel.currentUser.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())

                    // User greeting and name
                    VStack(alignment: .leading) {
                        Text(viewModel.currentUser.greeting)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text(viewModel.currentUser.name)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Notification and settings icons
                    HStack(spacing: 15) {
                        Image("noti_2")
                            .padding(7)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                        Image("settings")
                            .padding(7)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Balance Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Available Balance")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white.opacity(0.8))

                    // Display user's current balance in INR
                    Text("₹ \(String(format: "%.2f", viewModel.balance))")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // Action Buttons
                HStack(spacing: 20) {
                    // Withdraw button
                    Button(action: { showWithdraw = true }) {
                        Text("WITHDRAW")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    // Deposit button
                    Button(action: { showDeposit = true }) {
                        Text("DEPOSIT")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)

                Spacer().frame(height: 30)

                // Transaction History Section
                VStack {
                    // History header with expand/collapse toggle
                    HStack {
                        Text("History").font(.headline).bold()
                        Spacer()
                        Button(action: { withAnimation { isExpanded.toggle() } }) {
                            Text(isExpanded ? "Collapse" : "Expand")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 25)

                    // // Display transactions or empty state
                    if transactions.isEmpty {
                        Spacer()
                        EmptyStateView()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                // Show 5 transactions by default, 10 when expanded
                                ForEach(transactions.prefix(isExpanded ? 10 : 5)) { transaction in
                                    TransactionRow(viewModel: viewModel, transaction: transaction)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.lightBackground)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
            }
        }
        // Deposit sheet with SwiftData context
        .sheet(isPresented: $showDeposit) {
            TransferSheetView(viewModel: viewModel, mode: .deposit)
                .environment(\.modelContext, modelContext)
        }
        // Withdraw sheet with SwiftData context
        .sheet(isPresented: $showWithdraw) {
            TransferSheetView(viewModel: viewModel, mode: .withdraw)
                .environment(\.modelContext, modelContext)
        }
    }
}
