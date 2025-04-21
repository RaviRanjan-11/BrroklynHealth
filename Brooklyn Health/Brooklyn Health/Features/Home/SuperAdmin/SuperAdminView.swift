//
//  SuperAdminView.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import SwiftUI

struct SuperAdminView: View {
    @StateObject private var viewModel = SuperAdminViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var logout: Bool = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Super Admin Dashboard")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Logout") {
                    viewModel.logout()
                    presentationMode.wrappedValue.dismiss()

                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()

            // CareGiver List
            List {
                Section(header: Text("CareGivers")) {
                    ForEach(viewModel.caregivers, id: \.self) { caregiver in
                        NavigationLink(destination: CareGiverDetailsView(caregiver: caregiver)
                                        .environment(\.managedObjectContext, viewContext)) {
                            VStack(alignment: .leading) {
                                Text(caregiver.name ?? "")
                                    .font(.headline)
                                Text(caregiver.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)

            // Floating Form Button
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
                        .background(Circle().fill(Colors.primaryBackground))
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showingForm) {
            CreateCareGiverForm(viewModel: viewModel)
                .environment(\.managedObjectContext, viewContext)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Info"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModel.fetchCareGivers(context: viewContext)
        }

        NavigationLink(destination: LoginScreen().navigationBarBackButtonHidden(true), isActive: $logout) {
            EmptyView()
        }
    }
}

