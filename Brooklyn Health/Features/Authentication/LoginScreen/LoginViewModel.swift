//
//  LoginViewModel.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 19/04/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
}
