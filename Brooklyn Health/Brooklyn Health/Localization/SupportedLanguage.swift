//
//  SupportedLanguage.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import Foundation
enum SupportedLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case german = "de"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return LocalizeUtils.defaultLocalizer.stringForKey(key: "english")
        case .german: return LocalizeUtils.defaultLocalizer.stringForKey(key: "german")
        }
    }
}
