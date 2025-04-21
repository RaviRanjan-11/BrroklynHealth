//
//  CareGiverFormView.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import SwiftUI
import CoreData
struct CreateCareGiverForm: View {
    @ObservedObject var viewModel: SuperAdminViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("CareGiver Info")) {
                    TextField("Name", text: $viewModel.caregiverName)
                    TextField("Email", text: $viewModel.caregiverEmail)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $viewModel.caregiverPassword)
                }

                Button("Create CareGiver") {
                    viewModel.createCareGiver(context: viewContext)
                    if viewModel.alertMessage.contains("success") {
                        dismiss()
                    }
                }
                .disabled(viewModel.caregiverName.isEmpty || viewModel.caregiverEmail.isEmpty || viewModel.caregiverPassword.isEmpty)
            }
            .navigationTitle("New CareGiver")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
