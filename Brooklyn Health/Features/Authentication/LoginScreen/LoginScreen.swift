//
//  LoginScreen.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 19/04/25.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = LoginViewModel()
    
    @State private var fontSize: CGFloat = 25

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text(LocalizedKey.appName.key)
                    .foregroundStyle(Colors.primaryBackground)
                    .font(.system(size: fontSize, weight: .bold, design: .default))
                    .padding()
                
                TextField(LocalizedKey.email.key, text: $viewModel.email)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.primaryBackground, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                
                SecureField(LocalizedKey.password.key, text: $viewModel.password)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.primaryBackground, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text(LocalizedKey.forgotPassword.key)
                            .font(.headline)
                            .padding()
                            .frame(height: 30)
                            .foregroundColor(.orange)
                    }
                }
                Button(action: {}) {
                    Text(LocalizedKey.login.key)
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Colors.primaryBackground)
                        )
                        .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    LoginScreen()
}
