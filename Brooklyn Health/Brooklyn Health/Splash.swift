//
//  Splash.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 19/04/25.
//

import SwiftUI
import CoreData

struct Splash: View {
    @State private var fontSize: CGFloat = 25
    @State private var navigateToLogin = false
    @State private var showHome = false
    @State private var userType: UserType = .none

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            ZStack {
                Colors.primaryBackground
                    .ignoresSafeArea()

                VStack {
                    Text(Localized.appName.localized)
                        .foregroundStyle(.white)
                        .font(.system(size: fontSize, weight: .bold))
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2.0)) {
                                fontSize = 32
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                                let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
                                let type = UserDefaults.standard.string(forKey: "userType")

                                if isLoggedIn {
                                    fetchUser(email: userEmail, type: type)
                                } else {
                                    navigateToLogin = true
                                }
                            }
                        }

                    NavigationLink(destination: LoginScreen().navigationBarBackButtonHidden(), isActive: $navigateToLogin) {
                        EmptyView()
                    }
                    .hidden()

                    NavigationLink(destination: Home(userType: userType).navigationBarBackButtonHidden(), isActive: $showHome) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func fetchUser(email: String, type: String?) {
        if type == "superAdmin" {
            let fetchRequest: NSFetchRequest<SuperAdmin> = SuperAdmin.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)

            if let user = try? viewContext.fetch(fetchRequest).first {
                userType = .superAdmin(user)
                showHome = true
            } else {
                navigateToLogin = true
            }
        } else if type == "careGiver" {
            let fetchRequest: NSFetchRequest<CareGiver> = CareGiver.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)

            if let user = try? viewContext.fetch(fetchRequest).first {
                userType = .careGiver(user)
                showHome = true
            } else {
                navigateToLogin = true
            }
        } else {
            navigateToLogin = true
        }
    }
}

#Preview {
    Splash()
}
