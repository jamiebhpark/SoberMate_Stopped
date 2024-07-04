import SwiftUI

struct UserSettingsView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Section(header: Text("Profile Settings").font(.headline).padding(.top)) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Username")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            TextField("Enter your username", text: $username)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)

                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            TextField("Enter your email", text: $email)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .keyboardType(.emailAddress)

                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            VStack {
                                if showPassword {
                                    TextField("Enter your password", text: $password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                }
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Text(showPassword ? "Hide Password" : "Show Password")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        .padding()
                    }

                    Section(header: Text("App Settings").font(.headline).padding(.top)) {
                        Button(action: {
                            saveSettings()
                        }) {
                            Text("Save Settings")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()

                        Button(action: {
                            logOut()
                        }) {
                            Text("Log Out")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)

                        Button(action: {
                            toggleDarkMode()
                        }) {
                            Text(colorScheme == .dark ? "Switch to Light Mode" : "Switch to Dark Mode")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)

                        Button(action: {
                            shareApp()
                        }) {
                            Text("Share App")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)

                        Button(action: {
                            resetApp()
                        }) {
                            Text("Reset App")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarTitle("User Settings", displayMode: .inline)
        }
    }

    private func saveSettings() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            print("All fields must be filled.")
            return
        }
        // 사용자 설정 저장 로직을 추가하세요
        print("Settings saved: \(username), \(email)")
    }

    private func logOut() {
        // 로그아웃 로직을 추가하세요
        print("User logged out")
    }

    private func toggleDarkMode() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.overrideUserInterfaceStyle = window.overrideUserInterfaceStyle == .dark ? .light : .dark
    }

    private func shareApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        let url = URL(string: "https://example.com")!
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        window.rootViewController?.present(activityController, animated: true, completion: nil)
    }

    private func resetApp() {
        // 앱 전체 초기화 로직을 추가하세요
        print("App reset")
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
