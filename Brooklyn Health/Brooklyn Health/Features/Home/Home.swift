//
//  Home.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import SwiftUI

struct Home: View {
    var userType: UserType
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        switch userType {
        case .superAdmin(let superAdmin):
            SuperAdminView()
        case .careGiver(let careGiver):
            CareGiverDashboardView(careGiver: careGiver)
        case .none:
            Splash()
        }
    }
}


#Preview {
    Home(userType: .none)
}

