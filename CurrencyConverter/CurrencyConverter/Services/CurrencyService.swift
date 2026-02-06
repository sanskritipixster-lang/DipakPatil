//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by DipakPatil on 06/02/26.
//

import Foundation

// MARK: - Response Model

struct ExchangeRateResponse: Decodable {
    let conversion_rate: Double
}

// MARK: - Currency Service

// Service responsible for fetching currency exchange rates from the API
class CurrencyService {
    static func getConversionRate(from base: String, to target: String = "INR") async throws -> Double {
        // Construct the API endpoint URL
        let urlString = "\(Constants.AppUrl.baseURL)/\(Constants.AppUrl.apiKey)/pair/\(base)/\(target)"

        // Validate URL string
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        // Perform network request
        let (data, response) = try await URLSession.shared.data(from: url)

        // Validate HTTP response status
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Decode JSON response
        let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
        return decodedResponse.conversion_rate
    }
}
