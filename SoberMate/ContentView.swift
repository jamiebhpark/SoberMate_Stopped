import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("SoberMate")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    featureButton(title: "Set Goals", destination: GoalView(), iconName: "target")
                    featureButton(title: "Record Drinks", destination: RecordView(), iconName: "pencil")
                    featureButton(title: "Diary", destination: DiaryView(), iconName: "book")
                    featureButton(title: "Community", destination: CommunityView(), iconName: "person.2")
                    featureButton(title: "Statistics", destination: StatsView(), iconName: "chart.bar")
                    featureButton(title: "Achievements", destination: AchievementsView(), iconName: "star")
                    featureButton(title: "Emergency Contacts", destination: EmergencyView(), iconName: "phone")
                    featureButton(title: "Reminder Settings", destination: ReminderSettingsView(), iconName: "bell")
                    featureButton(title: "User Settings", destination: UserSettingsView(), iconName: "gear")
                }
                .padding()
            }
            .navigationBarTitle("SoberMate", displayMode: .inline)
        }
    }

    @ViewBuilder
    private func featureButton<Destination: View>(title: String, destination: Destination, iconName: String) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 10)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
