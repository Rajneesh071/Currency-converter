//
//  CurrencyConverterModel.swift
//  CurrencyConverter
//
//  Created by Rajneesh 2020/12/12
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import SwiftUI

enum UserDefaultKey: String {
    case exchangeRates = "exchangeRates"
    case currencyList = "currencyList"
}

class CurrencyConverterViewModel : ObservableObject {
    @Published var selectedCurrencyIndex : Int = 0
    @Published var exchangeRates : [ExchangeRate]?
    @Published var availableCurrencies : [CountryCurrency]?
    @Published var convertedRates : [ExchangeRate]?
    @Published var showAlert : Bool = false
    @Published var errorMessage: String = ""
    
    // used for Conversion API (not free)
    private var conversionAmount: Double = 1
    private var defaultCurrency: String = "USD"
    
    func convertCurrencyAmount(for currency: String?, amount: Double) {
        if let currency = currency {
            
            // find exchange rate for USD -> selected currency
            let usdToSelectedCurrencyRate = exchangeRates?.filter({
                $0.currency == currency
            })
            convertedRates = exchangeRates?.map({
                var rate: Double
                // because only usd is available for free version
                // so here I have calculated manually
                if currency == defaultCurrency {
                    rate = $0.rate * amount
                } else {
                    rate = ($0.rate / (usdToSelectedCurrencyRate?.first?.rate ?? 1))  * amount
                }
                return ExchangeRate(
                    currency: $0.currency,
                    rate: rate)
            })
        }
    }
    
    // MARK:- Currency list API
    
    func loadAllAvailableCurrencies() {
        CurrencyListRequest.sharedInstance.getAllCurrencies(
            success: { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.availableCurrencies = response?.currencies?.compactMap({
                        CountryCurrency(
                            code: $0.0,
                            name: $0.1)
                        })
                        .sorted() {
                            $0.code < $1.code
                        }
                    
                    /*
                     * using userdefaults for the sake of this test
                     * Would prefer core data, if had time
                     */
                    if let currencies = self.availableCurrencies {
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(currencies), forKey: UserDefaultKey.currencyList.rawValue)
                    }
                    
                    // Repeatition
                    Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { timer in
                        self.loadLiveCurrenciesExchangeRates()
                    }
                }
        },
            failure: { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.errorMessage = error.info
                    self.showAlert = true
                }
                print ("Couldn't load currency list")
        })
    }

    // MARK:- Live exchange API
    
    func loadLiveCurrenciesExchangeRates() {
        LiveExchangeRequest.sharedInstance.getLiveExchange(
            success: { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.exchangeRates = response?.quotes.compactMap({
                        ExchangeRate(
                            currency: $0.0.replacingOccurrences(of: self.defaultCurrency, with: "", options: String.CompareOptions.literal, range: $0.0.range(of: self.defaultCurrency)),
                            rate: $0.1)
                        })
                        .sorted() { $0.currency < $1.currency }
                    
                    /*
                     * using userdefaults for the sake of this test
                     * Would prefer core data, if had time
                     */
                    if let rates = self.exchangeRates {
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(rates), forKey: UserDefaultKey.exchangeRates.rawValue)
                    }
                }
            },
            failure: { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.errorMessage = error.info
                    self.showAlert = true
                }
                print ("Couldn't get live exchange rate")
            })
    }
    
    // MARK:- Conversion API
    
    /*
     * Can be used for converting amount to a specific currency
     * Not available for free users.
     */
    func loadConversionRate(from: String, to: String, amount: String) {
        CurrencyConversionRequest.sharedInstance.convertCurrency(
            from: from,
            to: to,
            amount: amount,
            success: { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.conversionAmount = response?.result ?? 0
                }
            },
            failure: { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert = true
                    self.errorMessage = error.info
                }
                print ("Couldn't convert currencies")
            })
    }
}
