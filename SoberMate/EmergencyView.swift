import SwiftUI
import Amplify

struct EmergencyView: View {
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var contacts: [EmergencyContact] = []
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(contacts, id: \.id) { contact in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text(contact.phone)
                            }
                            Spacer()
                            Button(action: {
                                callContact(phone: contact.phone)
                            }) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing, 10)
                            Button(action: {
                                messageContact(phone: contact.phone)
                            }) {
                                Image(systemName: "message.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .onDelete(perform: deleteContact)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Emergency Contacts")
                .navigationBarItems(trailing: EditButton())
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Contact Name", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    TextField("Phone Number", text: $phone)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .keyboardType(.phonePad)
                    Button(action: {
                        addContact()
                    }) {
                        Text("Add Contact")
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
            .onAppear(perform: fetchContacts)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addContact() {
        guard !name.isEmpty, !phone.isEmpty else {
            alertMessage = "Please enter both name and phone number."
            showAlert = true
            return
        }

        let newContact = EmergencyContact(
            id: UUID().uuidString,
            name: name,
            phone: phone,
            createdAt: Temporal.DateTime.now(),
            updatedAt: Temporal.DateTime.now(),
            _version: 1,
            _deleted: false,
            _lastChangedAt: Int(Date().timeIntervalSince1970 * 1000)        )

        Task {
            do {
                try await Amplify.DataStore.save(newContact)
                fetchContacts()
                name = ""
                phone = ""
            } catch {
                alertMessage = "Failed to add contact: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func fetchContacts() {
        Task {
            do {
                let contacts = try await Amplify.DataStore.query(EmergencyContact.self)
                self.contacts = contacts
            } catch {
                alertMessage = "Failed to fetch contacts: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func deleteContact(at offsets: IndexSet) {
        offsets.map { contacts[$0] }.forEach { contact in
            Task {
                do {
                    try await Amplify.DataStore.delete(contact)
                    fetchContacts()
                } catch {
                    alertMessage = "Failed to delete contact: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }

    private func callContact(phone: String) {
        if let phoneURL = URL(string: "tel://\(phone)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                alertMessage = "Your device cannot make phone calls."
                showAlert = true
            }
        }
    }

    private func messageContact(phone: String) {
        if let messageURL = URL(string: "sms://\(phone)") {
            if UIApplication.shared.canOpenURL(messageURL) {
                UIApplication.shared.open(messageURL, options: [:], completionHandler: nil)
            } else {
                alertMessage = "Your device cannot send messages."
                showAlert = true
            }
        }
    }
}
