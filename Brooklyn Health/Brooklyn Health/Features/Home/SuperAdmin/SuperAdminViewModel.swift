//
//  SuperAdminViewModel.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//


import Foundation
import CoreData

class SuperAdminViewModel: ObservableObject {
    @Published var caregiverName = ""
    @Published var caregiverEmail = ""
    @Published var caregiverPassword = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var caregivers: [CareGiver] = []
    @Published var showingForm = false


    func fetchCareGivers(context: NSManagedObjectContext) {
        let request: NSFetchRequest<CareGiver> = CareGiver.fetchRequest()
        do {
            caregivers = try context.fetch(request)
        } catch {
            alertMessage = "Failed to fetch caregivers: \(error.localizedDescription)"
            showAlert = true
        }
    }

    func createCareGiver(context: NSManagedObjectContext) {
        guard !caregiverName.isEmpty, !caregiverEmail.isEmpty, !caregiverPassword.isEmpty else {
            alertMessage = "Please fill all fields."
            showAlert = true
            return
        }
        
        let request: NSFetchRequest<CareGiver> = CareGiver.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", caregiverEmail)
        
        do {
            let existing = try context.fetch(request)
            if !existing.isEmpty {
                alertMessage = "A CareGiver with this email already exists."
                showAlert = true
                return
            }
            
            let caregiver = CareGiver(context: context)
            caregiver.name = caregiverName
            caregiver.email = caregiverEmail
            caregiver.password = caregiverPassword

            try context.save()
            alertMessage = "CareGiver created successfully!"
            showAlert = true
            
            // Reset form
            caregiverName = ""
            caregiverEmail = ""
            caregiverPassword = ""
            
            fetchCareGivers(context: context)
        } catch {
            alertMessage = "Failed to create CareGiver: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userType")
        UserDefaults.standard.removeObject(forKey: "userEmail")
    }
}
