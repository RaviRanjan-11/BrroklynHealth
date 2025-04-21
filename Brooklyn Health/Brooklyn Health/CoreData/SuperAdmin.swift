//
//  SuperAdmin.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import Foundation
import CoreData
extension PersistenceController {
    func createDefaultSuperAdminIfNeeded() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<SuperAdmin> = SuperAdmin.fetchRequest()

        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let superAdmin = SuperAdmin(context: context)
                superAdmin.id = UUID()
                superAdmin.email = "admin@brooklyn.com"
                superAdmin.name = "Super Admin"
                superAdmin.password = "Admin@123"

                try context.save()
                print("Default SuperAdmin created")
            } else {
                print("SuperAdmin already exists")
            }
        } catch {
            print("Failed to fetch/create SuperAdmin: \(error.localizedDescription)")
        }
    }
}
