import Foundation
import CoreData

class CareGiverViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var patientName: String = ""
    @Published var patientAge: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showingForm = false

    var caregiver: CareGiver?

    func setCaregiver(_ caregiver: CareGiver, context: NSManagedObjectContext) {
        self.caregiver = caregiver
        fetchPatients(context: context)
    }

    func fetchPatients(context: NSManagedObjectContext) {
        guard let caregiver = caregiver else { return }
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        request.predicate = NSPredicate(format: "careGiver == %@", caregiver)

        do {
            patients = try context.fetch(request)
        } catch {
            print("Error fetching patients: \(error.localizedDescription)")
        }
    }

    func addPatient(context: NSManagedObjectContext) {
        guard let caregiver = caregiver else { return }

        let newPatient = Patient(context: context)
        newPatient.name = patientName
        newPatient.age = Int16(patientAge) ?? 0
        newPatient.careGiver = caregiver

        do {
            try context.save()
            alertMessage = "Patient added successfully!"
            fetchPatients(context: context)
            patientName = ""
            patientAge = ""
            showingForm = false
        } catch {
            alertMessage = "Failed to add patient: \(error.localizedDescription)"
        }

        showAlert = true
    }
}
