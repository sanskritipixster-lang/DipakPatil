//
//  EmptyStateView.swift
//  BankApp
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.blue.opacity(0.5))

            Text("NO DATA")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
    }
}

