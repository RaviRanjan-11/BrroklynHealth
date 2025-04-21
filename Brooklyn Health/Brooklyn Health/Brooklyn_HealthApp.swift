//
//  Brooklyn_HealthApp.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 19/04/25.
//

import SwiftUI

@main
struct Brooklyn_HealthApp: App {
    let persistenceController = PersistenceController.shared

    init() {
            persistenceController.createDefaultSuperAdminIfNeeded()
        }
    var body: some Scene {
        WindowGroup {
            Splash()
                .environmentObject(LanguageViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
