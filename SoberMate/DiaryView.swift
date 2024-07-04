import SwiftUI
import Amplify

struct DiaryView: View {
    @State private var content: String = ""
    @State private var feeling: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSaving = false

    let feelings = ["😀", "😐", "😞", "😡"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Write in Your Diary")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Date")
                            .font(.headline)
                        DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)

                        Text("Your Thoughts")
                            .font(.headline)
                        TextField("Enter your thoughts", text: $content)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("How are you feeling?")
                            .font(.headline)
                        Picker("Select feeling", selection: $feeling) {
                            ForEach(feelings, id: \.self) { feeling in
                                Text(feeling).tag(feeling)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    if isSaving {
                        ProgressView("Saving Diary Entry...")
                            .padding()
                    } else {
                        Button(action: {
                            saveDiaryEntry()
                        }) {
                            Text("Save Diary Entry")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Diary Entry Saved"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("Diary", displayMode: .inline)
        }
    }

    private func saveDiaryEntry() {
        let dateFormatter = ISO8601DateFormatter()
        let selectedDateString = dateFormatter.string(from: selectedDate)
        
        do {
            let newEntry = try DiaryEntry(
                content: content,
                feeling: feeling,
                date: Temporal.Date(iso8601String: selectedDateString),
                createdAt: Temporal.DateTime.now(),
                updatedAt: Temporal.DateTime.now(),
                _version: 1,
                _deleted: false,
                _lastChangedAt: Int(Date().timeIntervalSince1970 * 1000)
            )

            isSaving = true

            Task {
                do {
                    try await Amplify.DataStore.save(newEntry)
                    print("Diary entry saved successfully!")
                    isSaving = false
                    alertMessage = "Your diary entry has been saved successfully."
                    showAlert = true
                } catch {
                    print("Failed to save diary entry: \(error)")
                    alertMessage = "Failed to save diary entry: \(error.localizedDescription)"
                    isSaving = false
                    showAlert = true
                }
            }
        } catch {
            print("Failed to create diary entry: \(error)")
            alertMessage = "Failed to create diary entry: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
