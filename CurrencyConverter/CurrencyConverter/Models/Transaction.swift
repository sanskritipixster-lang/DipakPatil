//
//  Transaction.swift
//  CurrencyConverter
//
//  Created by DipakPatil on 06/02/26.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var title: String
    var date: Date
    var amount: Double
    var typeString: String
    var currency: String

    init(title: String, date : Date, amount: Double, type: TransactionType, currency: String) {
        self.title = title
        self.date = date
        self.amount = amount
        self.typeString = type.rawValue
        self.currency = currency
    }

    var type: TransactionType {
        TransactionType(rawValue: typeString) ?? .deposit
    }
}
