//
//  KeypadButton.swift
//  BankApp
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI
import Combine

struct KeypadButton: View {
    var text: String
    var color: Color = Color.keypadButton
    var textColor: Color = .white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color)
                .foregroundColor(textColor)
                .cornerRadius(12)
        }
    }
}
