import SwiftUI
import Amplify

struct GoalView: View {
    @State private var goalName: String = ""
    @State private var goalReason: String = ""
    @State private var dailyLimit: String = ""
    @State private var reward: String = ""
    @State private var targetDate: Date = Date()
    @State private var showAlert = false
    @State private var isSaving = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Set Your Goal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Goal Name")
                            .font(.headline)
                        TextField("Enter goal name", text: $goalName)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("Goal Reason")
                            .font(.headline)
                        TextField("Enter goal reason", text: $goalReason)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("Daily Limit (Optional)")
                            .font(.headline)
                        TextField("Daily limit", text: $dailyLimit)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .keyboardType(.numberPad)
                        
                        Text("Reward (Optional)")
                            .font(.headline)
                        TextField("Reward", text: $reward)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("Target Date")
                            .font(.headline)
                        DatePicker("Select target date", selection: $targetDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    if isSaving {
                        ProgressView("Saving Goal...")
                            .padding()
                    } else {
                        Button(action: {
                            saveGoal()
                        }) {
                            Text("Save Goal")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Goal Saved"), message: Text("Your goal has been saved successfully."), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("Set Goals", displayMode: .inline)
        }
    }

    private func saveGoal() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let targetDateString = dateFormatter.string(from: targetDate)
        let dailyLimitInt = Int(dailyLimit) ?? 0

        do {
            let targetTemporalDate = try Temporal.Date(iso8601String: targetDateString)
            let newGoal = Goal(
                id: UUID().uuidString,
                description: goalName,
                targetDate: targetTemporalDate,
                reason: goalReason,
                dailyLimit: dailyLimitInt,
                reward: reward,
                createdAt: Temporal.DateTime.now(),
                updatedAt: Temporal.DateTime.now()
            )

            isSaving = true

            Task {
                do {
                    try await Amplify.DataStore.save(newGoal)
                    print("Goal saved successfully!")
                    isSaving = false
                    showAlert = true
                } catch {
                    print("Failed to save goal: \(error)")
                    isSaving = false
                }
            }
        } catch {
            print("Failed to create Temporal.Date: \(error)")
        }
    }
}
