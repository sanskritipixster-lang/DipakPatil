//
//  HomeView.swift
//  BankApp
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel

    // Context of SwiftData DB
    @Environment(\.modelContext) private var modelContext

    // Fetch data from SwiftData DB using Query handler
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]

    @State private var showDeposit = false
    @State private var showWithdraw = false
    @State private var isExpanded = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.brandBlue.ignoresSafeArea(edges: .top)
            VStack(spacing: 0) {
                HStack {
                    Image(viewModel.currentUser.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())

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

                    Text("₹ \(String(format: "%.2f", viewModel.balance))")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // Action Buttons
                HStack(spacing: 20) {
                    Button(action: { showWithdraw = true }) {
                        Text("WITHDRAW")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.brandBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    Button(action: { showDeposit = true }) {
                        Text("DEPOSIT")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.brandDarkBlue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)

                Spacer().frame(height: 30)

                // Transaction History Section
                VStack {
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

                    // 3. Check the Query results instead of viewModel.transactions
                    if transactions.isEmpty {
                        Spacer()
                        EmptyStateView()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                // 4. Display persistent data
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
        .sheet(isPresented: $showDeposit) {
            TransferSheetView(viewModel: viewModel, mode: .deposit)
                .environment(\.modelContext, modelContext)
        }
        .sheet(isPresented: $showWithdraw) {
            TransferSheetView(viewModel: viewModel, mode: .withdraw)
                .environment(\.modelContext, modelContext)
        }
    }
}
