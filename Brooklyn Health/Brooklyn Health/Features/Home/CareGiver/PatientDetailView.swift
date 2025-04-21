//
//  PatientDetailView.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 21/04/25.
//

import SwiftUI
import CoreData

struct PatientDetailView: View {
    @ObservedObject var viewModel: CareGiverViewModel
    let patient: Patient
    
    init(viewModel: CareGiverViewModel, patient: Patient) {
        self.viewModel = viewModel
        self.patient = patient
        viewModel.setupAudioManager(for: patient)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Patient Info Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(patient.name ?? "Unknown")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Age: \(patient.age)")
                        .font(.subheadline)
                    
                    if let address = patient.address {
                        Text("Address: \(address)")
                            .font(.subheadline)
                    }
                    
                    if let notes = patient.notes {
                        Text("Notes: \(notes)")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.05), radius: 3)
                
                // Audio Recordings Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Voice Recordings")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            if viewModel.audioManager.isRecording {
                                viewModel.audioManager.stopRecording()
                            } else {
                                viewModel.audioManager.startRecording()
                            }
                        }) {
//                            HStack {
//                                Image(systemName: viewModel.audioManager.isRecording ? "stop.circle.fill" : "mic.circle.fill")
//                                Text(viewModel.audioManager.isRecording ? "Stop" : "Record")
//                            }
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 6)
//                            .background(viewModel.audioManager.isRecording ? Color.red : Color.blue)
//                            .cornerRadius(8)
                        }
                    }
                    
                    if viewModel.audioManager.recordings.isEmpty {
                        Text("No recordings yet")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                    } else {
                        ForEach(viewModel.audioManager.recordings, id: \.self) { recording in
                            RecordingRow(recording: recording, audioManager: viewModel.audioManager)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.05), radius: 3)
            }
            .padding()
        }
        .background(Color(hex: "#F9F9F9"))
        .navigationTitle("Patient Details")
        .onAppear {
            viewModel.audioManager.fetchRecordings()
        }
    }
}
