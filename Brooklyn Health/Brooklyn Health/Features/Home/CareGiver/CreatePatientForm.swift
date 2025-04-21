//
//  CreatePatientForm.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//


import SwiftUI

struct CreatePatientForm: View {
    @ObservedObject var viewModel: CareGiverViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showRecordingControls = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#F9F9F9").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormFields
                        
                        
                        Spacer(minLength: 40)
                        
                        Button(action: {
                            viewModel.addPatient()
                        }) {
                            Text("Add Patient")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#4A5445"))
                                .cornerRadius(12)
                                .shadow(radius: 3)
                        }
                        .padding(.horizontal)
                        .disabled(viewModel.patientName.isEmpty || viewModel.patientAge.isEmpty)
                    }
                    .padding(.top)
                }
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
    
    var FormFields: some View {
        VStack(spacing: 16) {
            CustomTextField("Full Name", text: $viewModel.patientName)
            CustomTextField("Age", text: $viewModel.patientAge, keyboardType: .numberPad)
            CustomTextField("Address", text: $viewModel.patientAddress)
            CustomTextField("Notes", text: $viewModel.patientNotes)
        }
        .padding(.horizontal)
    }
    
    func CustomTextField(_ title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("", text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .keyboardType(keyboardType)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
    }
}
