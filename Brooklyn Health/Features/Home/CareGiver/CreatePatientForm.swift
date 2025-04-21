import SwiftUI

struct CreatePatientForm: View {
    @ObservedObject var viewModel: CareGiverViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Patient Info")) {
                    TextField("Name", text: $viewModel.patientName)
                    TextField("Age", text: $viewModel.patientAge)
                        .keyboardType(.numberPad)
                }

                Button("Add Patient") {
                    viewModel.addPatient(context: viewContext)
                }
                .disabled(viewModel.patientName.isEmpty || viewModel.patientAge.isEmpty)
            }
            .navigationTitle("New Patient")
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
