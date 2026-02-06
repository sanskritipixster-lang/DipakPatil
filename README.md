# CurrencyConverter

A SwiftUI iOS app for quick currency conversion with simple banking-style flows. It provides onboarding, a splash screen, live exchange-rate conversion to INR, and local transaction history using SwiftData.

## Features

- Splash screen and onboarding flow with persistent state.
- Live exchange-rate conversion using ExchangeRate-API (with fallback static rates).
- Deposit and withdraw flows with currency selection and a custom keypad.
- Local transaction history stored in SwiftData and displayed in the Home screen.
- Persistent balance and onboarding completion stored in `@AppStorage`.

## Screens

- Onboarding: welcome screen and get-started action.
- Home: balance, quick actions (deposit/withdraw), and transaction history.
- Transfer sheet: currency picker, numeric keypad, and validation.

## Tech Stack

- SwiftUI
- SwiftData
- Combine
- ExchangeRate-API (v6)

## Project Structure

```
CurrencyConverter/
  CurrencyConverter/
    Extensions/
    Models/
    Resources/
    Services/
    Utils/
    ViewModels/
    Views/
```

## Architecture

The app follows MVVM:

- `AppViewModel` handles balance, API calls, and transaction creation.
- Views read and react to state via `@ObservedObject` and `@Published`.
- `CurrencyService` encapsulates exchange-rate API calls.
- Transactions are persisted in SwiftData.

## Data Storage

- `@AppStorage("user_balance")` stores the INR balance.
- `@AppStorage("hasFinishedOnboarding")` stores onboarding completion.
- `Transaction` models are persisted in SwiftData.

## API Configuration

The app uses ExchangeRate-API and expects an API key in:

- `Constants.AppUrl.apiKey` in [CurrencyConverter/CurrencyConverter/Utils/Constants.swift](CurrencyConverter/CurrencyConverter/Utils/Constants.swift)

Replace the placeholder key with your own key from https://www.exchangerate-api.com/.

## Requirements

- Xcode 15 or newer
- iOS 17 or newer (SwiftData)
- macOS 13 or newer

## Build and Run

1. Open [CurrencyConverter/CurrencyConverter.xcodeproj](CurrencyConverter/CurrencyConverter.xcodeproj) in Xcode.
2. Select a target device or simulator.
3. Build and run.

## Usage

- Complete onboarding once.
- Use Deposit or Withdraw to open the transfer sheet.
- Select a currency, enter an amount using the keypad, and confirm.
- View recent transactions in the History section.

## Fallback Rates

If the API is unavailable, the app uses static fallback rates in:

- [CurrencyConverter/CurrencyConverter/ViewModels/AppViewModel.swift](CurrencyConverter/CurrencyConverter/ViewModels/AppViewModel.swift)

## Notes

- Balances and transactions are local-only; there is no cloud sync.
- Currency conversions are always normalized to INR.

## License

Add your license here.
