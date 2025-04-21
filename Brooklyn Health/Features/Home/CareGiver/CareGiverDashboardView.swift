//
//  CareGiverView.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//


import SwiftUI

struct CareGiverDashboardView: View {
    @StateObject private var viewModel: CareGiverViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    init(careGiver: CareGiver) {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: CareGiverViewModel(caregiver: careGiver, context: context))
    }

    var body: some View {
        VStack {
            HStack {
                Text("CareGiver Dashboard")
                    .font(.title2)
                    .bold()
                Spacer()
                Button("Logout") {
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    UserDefaults.standard.removeObject(forKey: "userType")
                    UserDefaults.standard.removeObject(forKey: "userEmail")
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()

            List {
                Section(header: Text("Patients")) {
                    ForEach(viewModel.patients, id: \.self) { patient in
                        VStack(alignment: .leading) {
                            Text(patient.name ?? "")
                                .font(.headline)
                            Text("Age: \(patient.age)")
                                .font(.subheadline)
                        }
                    }
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button(action: {
                    viewModel.showingForm.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showingForm) {
            VStack {
                TextField("Name", text: $viewModel.patientName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Age", text: $viewModel.patientAge)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Add Patient") {
                    viewModel.addPatient()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Info"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
