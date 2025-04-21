//
//  Localization.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 19/04/25.
//

import Foundation
import SwiftUI


class LocalizeUtils: NSObject {
    static let defaultLocalizer = LocalizeUtils()
    var appbundle = Bundle.main
    
    override init() {
        super.init()
        
        // Check if a language is already saved in UserDefaults
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            setSelectedLanguage(lang: savedLanguage)
        } else {
            // Default to English if no language is selected
            setSelectedLanguage(lang: "en")
        }
    }
    
    func setSelectedLanguage(lang: String) {
        guard let langPath = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: langPath) else {
            appbundle = Bundle.main
            return
        }
        appbundle = bundle
        
        // Save the selected language for future launches
        UserDefaults.standard.set(lang, forKey: "selectedLanguage")
    }
    
    func stringForKey(key: String) -> String {
        return appbundle.localizedString(forKey: key, value: "", table: nil)
    }
}


