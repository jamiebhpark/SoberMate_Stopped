import SwiftUI
import Amplify

struct RecordView: View {
    @State private var details: String = ""
    @State private var amount: String = ""
    @State private var content: String = ""
    @State private var feeling: String = ""
    @State private var location: String = ""
    @State private var showAlert = false
    @State private var isSaving = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Record Your Drink")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Drink Details")
                            .font(.headline)
                        TextField("Enter drink details", text: $details)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("Amount")
                            .font(.headline)
                        TextField("Enter amount", text: $amount)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .keyboardType(.numberPad)
                        
                        Text("Content")
                            .font(.headline)
                        TextField("Enter content", text: $content)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("Feeling")
                            .font(.headline)
                        TextField("Enter your feeling", text: $feeling)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)

                        Text("Location")
                            .font(.headline)
                        TextField("Enter location", text: $location)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    if isSaving {
                        ProgressView("Saving Record...")
                            .padding()
                    } else {
                        Button(action: {
                            saveRecord()
                        }) {
                            Text("Save Record")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Record Saved"), message: Text("Your drink record has been saved successfully."), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("Record Drinks", displayMode: .inline)
        }
    }

    private func saveRecord() {
        guard let amountInt = Int(amount) else { return }

        let newRecord = DrinkRecord(
            id: UUID().uuidString,
            details: details,
            amount: amountInt,
            content: content,
            feeling: feeling,
            location: location,
            createdAt: Temporal.DateTime.now(),
            updatedAt: Temporal.DateTime.now(),
            _version: 1,
            _deleted: false,
            _lastChangedAt: Int(Date().timeIntervalSince1970 * 1000)
        )

        isSaving = true

        Task {
            do {
                try await Amplify.DataStore.save(newRecord)
                print("Record saved successfully!")
                isSaving = false
                showAlert = true
            } catch {
                print("Failed to save record: \(error)")
                isSaving = false
            }
        }
    }
}
