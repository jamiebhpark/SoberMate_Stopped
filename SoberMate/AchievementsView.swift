import SwiftUI

struct LocalAchievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isUnlocked: Bool
}

struct AchievementsView: View {
    @State private var achievements: [LocalAchievement] = [
        LocalAchievement(title: "First Day Sober", description: "Stay sober for one day.", isUnlocked: true),
        LocalAchievement(title: "One Week Sober", description: "Stay sober for one week.", isUnlocked: false),
        LocalAchievement(title: "First Journal Entry", description: "Write your first journal entry.", isUnlocked: true),
        LocalAchievement(title: "Ten Journal Entries", description: "Write ten journal entries.", isUnlocked: false)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Achievements")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    ForEach(achievements) { achievement in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(achievement.title)
                                    .font(.headline)
                                    .foregroundColor(achievement.isUnlocked ? .primary : .gray)
                                Text(achievement.description)
                                    .font(.subheadline)
                                    .foregroundColor(achievement.isUnlocked ? .primary : .gray)
                            }
                            Spacer()
                            if achievement.isUnlocked {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .imageScale(.large)
                            } else {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                    .imageScale(.large)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("Achievements", displayMode: .inline)
        }
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
