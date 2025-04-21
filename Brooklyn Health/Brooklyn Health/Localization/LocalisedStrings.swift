//
//  LocalisedStrings.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import Foundation

enum Localized: String {
    
    case appName = "app_name"
    case email = "email"
    case password = "password"
    case login = "login"
    case forgotPassword = "forgot_password"
    case english = "english"
    case german = "german"
    case success = "success"
    case ok = "ok"
    case error = "error"
    case caregiver_success_login = "caregiver_success_login"
    case invailid_password = "invailid_password"
    case logged_in_failed = "logged_in_failed"
    case super_admin_success_login = "super_admin_success_login"
    case user_not_found = "user_not_found"
    
    var localized: String {
        LocalizeUtils.defaultLocalizer.stringForKey(key: self.rawValue)
    }
}
