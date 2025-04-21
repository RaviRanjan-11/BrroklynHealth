struct CareGiverDetailsView: View {
    var caregiver: CareGiver
    @Environment(\.managedObjectContext) private var viewContext
    @State private var patients: [Patient] = []

    var body: some View {
        VStack {
            Text("CareGiver: \(caregiver.name ?? "")")
                .font(.title)
                .padding()

            List(patients, id: \.self) { patient in
                VStack(alignment: .leading) {
                    Text(patient.name ?? "")
                        .font(.headline)
                    Text("Age: \(patient.age)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                fetchPatients()
            }
        }
        .navigationTitle("Patients of \(caregiver.name ?? "")")
        .padding()
    }

    func fetchPatients() {
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        request.predicate = NSPredicate(format: "careGiver == %@", caregiver)

        do {
            patients = try viewContext.fetch(request)
        } catch {
            print("Error fetching patients: \(error.localizedDescription)")
        }
    }
}
