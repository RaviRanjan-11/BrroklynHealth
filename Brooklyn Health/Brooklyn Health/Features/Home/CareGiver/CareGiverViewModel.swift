//
//  CareGiverViewModel.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//


import Foundation
import CoreData

class CareGiverViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var patientName: String = ""
    @Published var patientAge: String = ""
    @Published var patientAddress: String = ""
    @Published var patientNotes: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showingForm = false
    private var _audioManager: AudioRecordingManager?


    private var caregiver: CareGiver
    private var context: NSManagedObjectContext

    init(caregiver: CareGiver, context: NSManagedObjectContext) {
        self.caregiver = caregiver
        self.context = context
        fetchPatients()
    }

    // Fetch Patients for the Caregiver
    func fetchPatients() {
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        request.predicate = NSPredicate(format: "careGiver == %@", caregiver)

        do {
            patients = try context.fetch(request)
        } catch {
            print("Error fetching patients: \(error.localizedDescription)")
        }
    }

    // Add new patient
    func addPatient() {
        // Validate input fields
        guard !patientName.isEmpty, !patientAge.isEmpty, !patientAddress.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }

        // Create new patient object
        let newPatient = Patient(context: context)
        newPatient.name = patientName
        newPatient.age = Int16(patientAge) ?? 0
        newPatient.address = patientAddress
        newPatient.notes = patientNotes
        newPatient.careGiver = caregiver

        do {
            // Save the new patient
            try context.save()
            alertMessage = "Patient added successfully!"
            fetchPatients()
            clearForm()  
        } catch {
            alertMessage = "Failed to add patient: \(error.localizedDescription)"
        }

        showAlert = true
    }

    // Clear form fields
    func clearForm() {
        patientName = ""
        patientAge = ""
        patientAddress = ""
        patientNotes = ""
        showingForm = false
    }
}

extension CareGiverViewModel {
    // Add the audio recording manager as a computed property
    var audioManager: AudioRecordingManager {
        if _audioManager == nil {
            _audioManager = AudioRecordingManager(context: context)
        }
        return _audioManager!
    }
    
    // Additional initialization to set up AudioRecordingManager
    func setupAudioManager(for patient: Patient) {
        audioManager.setPatient(patient)
    }
}
