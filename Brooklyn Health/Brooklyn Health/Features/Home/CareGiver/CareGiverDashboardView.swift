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
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("CareGiver Dashboard")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button("Logout") {
                        logout()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.green)
                
                // Patients List
                List {
                    Section(header: Text("Patients")
                                .font(.headline)
                                .foregroundColor(.gray)) {
                        ForEach(viewModel.patients, id: \.self) { patient in
                            NavigationLink(destination: PatientDetailView(viewModel: viewModel, patient: patient)) {
                                VStack(alignment: .leading) {
                                    Text(patient.name ?? "")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Age: \(patient.age)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    if let address = patient.address {
                                        Text("Address: \(address)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                // Floating Button to add new patient
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
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showingForm) {
                CreatePatientForm(viewModel: viewModel)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Info"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Function to handle logout
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userType")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        presentationMode.wrappedValue.dismiss()
    }
}
