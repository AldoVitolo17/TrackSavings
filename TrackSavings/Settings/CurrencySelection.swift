//
//  CurrencySelection.swift
//  TrackSavings
//
//  Created by Raymundo Mondragon Lara on 19/02/24.
//

import SwiftUI

struct CurrencySelection: View {
    @Binding var selectedCurrency: String
    let currencies = ["USD", "EUR", "JPY"] // Add more currencies as needed

    var body: some View {
        List(currencies, id: \.self) { currency in
            Button(currency) {
                selectedCurrency = currency
            }
        }
    }
}
