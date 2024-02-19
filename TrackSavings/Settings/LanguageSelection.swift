//
//  LanguageSelection.swift
//  TrackSavings
//
//  Created by Raymundo Mondragon Lara on 19/02/24.
//

import SwiftUI

struct LanguageSelection: View {
    @Binding var selectedLanguage: String
    let languages = ["English", "Spanish", "French"] // Add more languages as needed

    var body: some View {
        List(languages, id: \.self) { language in
            Button(language) {
                selectedLanguage = language
            }
        }
    }
}

