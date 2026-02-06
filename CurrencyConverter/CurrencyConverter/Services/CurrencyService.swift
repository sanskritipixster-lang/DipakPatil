//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by DipakPatil on 06/02/26.
//

import Foundation

// API Response model
struct ExchangeRateResponse: Decodable {
    let conversion_rate: Double
}

class CurrencyService {
    static func getConversionRate(from base: String, to target: String = "INR") async throws -> Double {
        let urlString = "\(Constants.AppUrl.baseURL)/\(Constants.AppUrl.apiKey)/pair/\(base)/\(target)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Check for valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
        return decodedResponse.conversion_rate
    }
}
