//
//  CustomKeypad.swift
//  BankApp
//
//  Created by DipakPatil on 06/02/26.
//

import SwiftUI

struct CustomKeypad: View {
    @Binding var enteredValue: String
    var onConfirm: () -> Void

    let spacing: CGFloat = 12
    let buttonHeight: CGFloat = 65

    var body: some View {
        HStack(alignment: .top, spacing: spacing) {

            VStack(spacing: spacing) {
                createRow(["7", "8", "9"])
                createRow(["4", "5", "6"])
                createRow(["1", "2", "3"])
                createRow(["0", "00", "."])
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: spacing) {
                actionButton(label: "AC", color: Color(white: 0.25), height: (buttonHeight * 2) + spacing) {
                    enteredValue = ""
                }

                actionButton(systemImage: "delete.left.fill", color: .red.opacity(0.8), height: buttonHeight) {
                    if !enteredValue.isEmpty { enteredValue.removeLast() }
                }

                actionButton(systemImage: "checkmark", color: .green, height: buttonHeight) {
                    onConfirm()
                }
            }
            .frame(width: 80)
        }
        .padding()
    }

    private func createRow(_ keys: [String]) -> some View {
        HStack(spacing: spacing) {
            ForEach(keys, id: \.self) { key in
                Button(action: { append(key) }) {
                    Text(key)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonHeight)
                        .background(Color(white: 0.15))
                        .cornerRadius(15)
                }
            }
        }
    }

    private func actionButton(label: String? = nil, systemImage: String? = nil, color: Color, height: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Group {
                if let label = label {
                    Text(label).font(.headline)
                } else if let systemImage = systemImage {
                    Image(systemName: systemImage).font(.title2)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(color)
            .cornerRadius(15)
        }
    }

    private func append(_ val: String) {
        // 1. Prevent multiple decimals
        if val == "." && enteredValue.contains(".") { return }

        // 2. Handle initial state
        if enteredValue.isEmpty || enteredValue == "0" {
            if val == "." {
                enteredValue = "0."
            } else if val == "00" || val == "0" {
                enteredValue = "0"
            } else {
                enteredValue = val
            }
            return
        }

        // 3. Prevent typing more than 2 decimal places (standard for currency)
        if let dotIndex = enteredValue.firstIndex(of: ".") {
            let decimalPart = enteredValue.distance(from: dotIndex, to: enteredValue.endIndex)
            if decimalPart > 2 { return }
        }

        enteredValue += val
    }
}
