//
//  LoginViewModel.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 19/04/25.
//

import Foundation
import CoreData

enum UserType {
    case superAdmin(SuperAdmin)
    case careGiver(CareGiver)
    case none
}

class LoginViewModel: ObservableObject {
    @Published var email: String = "admin@brooklyn.com"
    @Published var password: String = "Admin@123"
    @Published var loginError: String?
    @Published var loggedInUserType: UserType = .none

    func login(context: NSManagedObjectContext, completion: @escaping (Bool, String) -> Void) {
        let superFetch: NSFetchRequest<SuperAdmin> = SuperAdmin.fetchRequest()
        superFetch.predicate = NSPredicate(format: "email == %@", email)

        do {
            if let superAdmin = try context.fetch(superFetch).first {
                if superAdmin.password == password {
                    loggedInUserType = .superAdmin(superAdmin)

                    // 🔐 Save login state
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set("superAdmin", forKey: "userType")
                    UserDefaults.standard.set(email, forKey: "userEmail")

                    completion(true, Localized.super_admin_success_login.localized)
                    return
                } else {
                    completion(false, Localized.invailid_password.localized)
                    return
                }
            }

            // Try to find CareGiver
            let careFetch: NSFetchRequest<CareGiver> = CareGiver.fetchRequest()
            careFetch.predicate = NSPredicate(format: "email == %@", email)

            if let careGiver = try context.fetch(careFetch).first {
                if careGiver.password == password {
                    loggedInUserType = .careGiver(careGiver)

                    // 🔐 Save login state
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set("careGiver", forKey: "userType")
                    UserDefaults.standard.set(email, forKey: "userEmail")

                    completion(true, Localized.caregiver_success_login.localized)
                    return
                } else {
                    completion(false, Localized.invailid_password.localized)
                    return
                }
            }

            completion(false, Localized.user_not_found.localized)
        } catch {
            completion(false, "\(Localized.password.localized) \(error.localizedDescription)")
        }
    }

}
