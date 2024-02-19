//
//  SettingsMenu.swift
//  TrackSavings
//
//  Created by Raymundo Mondragon Lara on 19/02/24.
//

import SwiftUI

struct SettingsMenu: View {
    @Binding var selectedLanguage: String
    @Binding var selectedCurrency: String
    @State private var showingLanguages = false
    @State private var showingCurrencies = false

    var body: some View {
        List {
            Button("Language") {
                showingLanguages.toggle()
            }
            .sheet(isPresented: $showingLanguages) {
                // Present a list of languages
                LanguageSelection(selectedLanguage: $selectedLanguage)
            }

            Button("Currency") {
                showingCurrencies.toggle()
            }
            .sheet(isPresented: $showingCurrencies) {
                // Present a list of currencies
                CurrencySelection(selectedCurrency: $selectedCurrency)
            }
        }
    }
}

