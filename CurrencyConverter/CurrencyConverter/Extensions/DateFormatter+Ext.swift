//
//  DateFormatter+Ext.swift
//  CurrencyConverter
//
//  Created by DipakPatil on 06/02/26.
//

import Foundation

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
}
