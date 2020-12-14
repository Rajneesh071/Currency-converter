# Currency-converter

This project uses https://currencylayer.com/ free API to convert currencies. 
Using **SwifUI Framework** (MVVM). It doesn't use any external libraries.

## APIs Used
  - live (to get live all exchange rate)
  - list (to get list of all the currencies)
  - convert the currency which is not available in list (not for free user) 

## Functionality
- [x] Exchange rates must be fetched from: https://currencylayer.com/documentation
- [x] Use free API Access Key for using the API
- [x] User must be able to select a currency from a list of currencies provided by the API
- [x] User must be able to enter desired amount for selected currency
- [x] User should then see a list of exchange rates for the selected currency
- [x] Rates are fetching from cache instead of fetching from server. (Logic of 30 minutes)
