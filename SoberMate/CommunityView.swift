import SwiftUI
import Amplify

struct CommunityView: View {
    @State private var message: String = ""
    @State private var messages: [CommunityMessage] = []

    var body: some View {
        VStack {
            List(messages, id: \.id) { message in
                VStack(alignment: .leading) {
                    Text(message.sender)
                        .font(.headline)
                    Text(message.content)
                }
            }
            HStack {
                TextField("Enter message", text: $message)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    Task {
                        await sendMessage()
                    }
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarTitle("Community", displayMode: .inline)
        .onAppear {
            Task {
                await fetchMessages()
            }
        }
    }

    private func sendMessage() async {
        // `_version`, `_deleted`, `_lastChangedAt` 값을 초기화
        let newMessage = CommunityMessage(
            id: UUID().uuidString,
            content: message,
            sender: "User",
            createdAt: Temporal.DateTime.now(),
            updatedAt: Temporal.DateTime.now(),
            _version: 1,
            _deleted: false,
            _lastChangedAt: Int(Date().timeIntervalSince1970 * 1000)
        )

        do {
            let savedMessage = try await Amplify.DataStore.save(newMessage)
            print("Message saved successfully!")
            await fetchMessages() // 새 메시지를 추가한 후 메시지 새로 고침
            message = ""
        } catch {
            print("Failed to save message: \(error)")
        }
    }

    private func fetchMessages() async {
        do {
            let messages = try await Amplify.DataStore.query(CommunityMessage.self)
            self.messages = messages
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }

    private func deleteMessages(offsets: IndexSet) {
        withAnimation {
            offsets.map { messages[$0] }.forEach { message in
                Task {
                    await deleteMessage(message: message)
                }
            }
        }
    }

    private func deleteMessage(message: CommunityMessage) async {
        do {
            try await Amplify.DataStore.delete(message)
            await fetchMessages()
        } catch {
            print("Failed to delete message: \(error)")
        }
    }

    struct CommunityView_Previews: PreviewProvider {
        static var previews: some View {
            CommunityView()
        }
    }
}
