//
//  LanguageViewModel.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import Foundation
class LanguageViewModel: ObservableObject {
    @Published var isLanguageTapped: Bool = false
    @Published var selectedLanguage: SupportedLanguage = .english {
        didSet {
            LocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: selectedLanguage.rawValue)
        }
    }

    func selectLanguage(_ language: SupportedLanguage) {
        selectedLanguage = language
    }
}
