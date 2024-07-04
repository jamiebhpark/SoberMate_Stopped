import SwiftUI
import Amplify

extension Temporal.DateTime {
    var dateValue: Date {
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.date(from: self.iso8601String) ?? Date()
    }
}

struct ReminderSettingsView: View {
    @State private var reminderMessage: String = ""
    @State private var reminderTime: Date = Date()
    @State private var reminders: [Reminder] = []
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(reminders, id: \.id) { reminder in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(reminder.message)
                                    .font(.headline)
                                Text(reminder.time.dateValue, style: .time)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Toggle(isOn: .constant(true)) {
                                Text("")
                            }
                            .labelsHidden()
                        }
                    }
                    .onDelete(perform: deleteReminder)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Reminder Settings")
                .navigationBarItems(trailing: EditButton())
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Reminder Message", text: $reminderMessage)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    Button(action: {
                        saveReminder()
                    }) {
                        Text("Save Reminder")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.vertical)
                }
                .padding()
            }
            .onAppear(perform: fetchReminders)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveReminder() {
        guard !reminderMessage.isEmpty else {
            alertMessage = "Please enter a reminder message."
            showAlert = true
            return
        }

        let newReminder = Reminder(
            id: UUID().uuidString,
            message: reminderMessage,
            time: Temporal.DateTime(reminderTime),
            isEnabled: true,
            createdAt: Temporal.DateTime.now(),
            updatedAt: Temporal.DateTime.now(),
            _version: 1,
            _deleted: false,
            _lastChangedAt: Int(Date().timeIntervalSince1970 * 1000)
        )

        Task {
            do {
                try await Amplify.DataStore.save(newReminder)
                fetchReminders()
                reminderMessage = ""
                reminderTime = Date()
            } catch {
                alertMessage = "Failed to save reminder: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func fetchReminders() {
        Task {
            do {
                let reminders = try await Amplify.DataStore.query(Reminder.self)
                self.reminders = reminders
            } catch {
                alertMessage = "Failed to fetch reminders: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func deleteReminder(at offsets: IndexSet) {
        offsets.map { reminders[$0] }.forEach { reminder in
            Task {
                do {
                    try await Amplify.DataStore.delete(reminder)
                    fetchReminders()
                } catch {
                    alertMessage = "Failed to delete reminder: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}
