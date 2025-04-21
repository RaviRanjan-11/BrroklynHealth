//
//  LoginScreen.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 19/04/25.
//

import SwiftUI

struct LoginScreen: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var langViewModel: LanguageViewModel
    @Environment(\.managedObjectContext) var viewContext

    @State private var fontSize: CGFloat = 25
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        LanguageDropdown()
                    }
                    .padding(.horizontal, 16)

                    Spacer()

                    VStack(spacing: 16) {
                        Text(Localized.appName.localized)
                            .foregroundStyle(Colors.primaryBackground)
                            .font(.system(size: fontSize, weight: .bold))
                            .padding()

                        TextField(Localized.email.localized, text: $viewModel.email)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Colors.primaryBackground, lineWidth: 2))
                            .keyboardType(.emailAddress)
                            .padding(.horizontal, 20)

                        SecureField(Localized.password.localized, text: $viewModel.password)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Colors.primaryBackground, lineWidth: 2))
                            .padding(.horizontal, 20)

                        HStack {
                            Spacer()
                            Button(action: {}) {
                                Text(Localized.forgotPassword.localized)
                                    .font(.headline)
                                    .padding()
                                    .frame(height: 30)
                                    .foregroundColor(.orange)
                            }
                        }

                        Button(action: {
                            viewModel.login(context: viewContext) { success, message in
                                alertTitle = success ? Localized.success.localized : Localized.error.localized
                                alertMessage = message
                                if !success {
                                    showAlert = true
                                }

                                if success {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        isLoggedIn = true
                                    }
                                }
                            }
                        }) {
                            Text(Localized.login.localized)
                                .font(.headline)
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Colors.primaryBackground))
                                .padding(.horizontal, 20)
                        }

                        NavigationLink(destination: destinationView(for: viewModel.loggedInUserType).navigationBarBackButtonHidden(true), isActive: $isLoggedIn) {
                            EmptyView()
                        }
                        
                    }

                    Spacer()
                }
            }
            .id(langViewModel.selectedLanguage)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    func destinationView(for userType: UserType) -> some View {
            switch userType {
            case .superAdmin(let superAdmin):
                return AnyView(SuperAdminView())
            case .careGiver(let careGiver):
                return AnyView(CareGiverDashboardView(careGiver: careGiver))
            case .none:
                return AnyView(EmptyView())
            }
        }}

#Preview {
    LoginScreen()
        .environmentObject(LanguageViewModel())
}
