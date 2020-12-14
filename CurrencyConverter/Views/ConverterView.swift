//
//  ConverterView.swift
//  CurrencyConverter
//
//  Created by Rajneesh 2020/12/12
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import SwiftUI

struct ConverterView: View {
    
    @ObservedObject var model: CurrencyConverterViewModel = CurrencyConverterViewModel()
    @State var searchedAmount: String = ""
    @State var shouldShowCurrencyList: Bool = false
    
    var selectedCurrency: CountryCurrency? {
        return self.model.availableCurrencies?[self.model.selectedCurrencyIndex]
    }
    @State var location: String = ""
    
    
    var body: some View {
        VStack {
            // Header View
            headerView
            // Result View
            resultView
        }
        .padding(10)
        .padding(.top, .zero)
        .sheet(isPresented: $shouldShowCurrencyList) {
            // list of currencies
            if self.model.availableCurrencies?.count ?? 0 > 0 {
                List(0..<self.model.availableCurrencies!.count) { index in
                    Button(action: {
                        self.model.selectedCurrencyIndex = index
                        self.shouldShowCurrencyList = false
                        self.convertCurrency()
                    }) {
                        HStack {
                            Text("\(self.model.availableCurrencies![index].code)")
                            Spacer()
                            Text("\(self.model.availableCurrencies![index].name)")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .alert(isPresented: self.$model.showAlert) {
            Alert(title: Text(self.model.errorMessage))
        }
        .onAppear {
            if self.model.availableCurrencies == nil {
                self.model.loadAllAvailableCurrencies()
            }
            
            if self.model.convertedRates == nil {
                self.model.loadLiveCurrenciesExchangeRates()
            }
        }
    }
    
    var headerView: some View {
        let searchedAmountBinding = Binding<String>(get: {
            self.searchedAmount
        }, set: {
            self.searchedAmount = $0
            // perform currency conversion
            self.convertCurrency()
        })
        
        return VStack {
            TextField(
                " Enter amount here (default = 1)",
                text: searchedAmountBinding,
                onCommit: {
                    self.searchedAmount = self.searchedAmount.reduce("") {
                        if ("0"..."9").contains($1) || $1 == "." && !$0.contains($1) {
                            return $0 + "\($1)"
                        }
                        return $0
                    }
                    // load conversion rate for selected currency
                    self.convertCurrency()
            })
                .keyboardType(.decimalPad)
                .frame(height: 40)
                .border(Color.gray, width: 2)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
            HStack {
                Button(action: {
                    // Show currency list
                    self.shouldShowCurrencyList = true
                }) {
                    HStack {
                        Text(selectedCurrency?.code ?? "Select your currency")
                            .multilineTextAlignment(.trailing)
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                        Image(systemName: "chevron.down") // down arrow
                            .padding(.leading, 5)
                            .padding(.trailing, 10)
                    }
                }
                .border(Color.gray, width: 1)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.bottom, 10)
            
            Divider().background(Color.gray)
        }
    }
    
    var resultView: some View {
        VStack(alignment: .leading) {
            Text("Total Results (\(model.convertedRates?.count ?? 0))")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Divider().background(Color.gray)
            if model.convertedRates != nil {
                List(0..<self.model.convertedRates!.count) { index in
                    HStack {
                        Text("\(self.model.convertedRates![index].currency)")
                        Spacer()
                        Text("\(self.model.convertedRates![index].rate)")
                    }
                    .frame(maxWidth: .infinity)
                }.padding(.bottom, .zero)
            }
        }
    }
    
    func convertCurrency() {
        // conversion rate for selected currency
        self.model.convertCurrencyAmount(
            for: self.model.availableCurrencies?[self.model.selectedCurrencyIndex].code,
            amount: Double(self.searchedAmount) ?? 1)
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
    }
}
