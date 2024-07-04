import SwiftUI
import Charts // SwiftUI Charts를 사용할 수 있습니다.

struct StatsView: View {
    @State private var selectedTimeFrame: String = "Weekly"
    let timeFrames = ["Daily", "Weekly", "Monthly"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Your Statistics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    Picker("Select Time Frame", selection: $selectedTimeFrame) {
                        ForEach(timeFrames, id: \.self) { timeFrame in
                            Text(timeFrame).tag(timeFrame)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    // Total Drinks Consumed
                    Group {
                        Text("Total Drinks Consumed")
                            .font(.headline)
                        Chart {
                            BarMark(
                                x: .value("Date", "July 1"),
                                y: .value("Drinks", 2)
                            )
                            BarMark(
                                x: .value("Date", "July 2"),
                                y: .value("Drinks", 3)
                            )
                            BarMark(
                                x: .value("Date", "July 3"),
                                y: .value("Drinks", 1)
                            )
                        }
                        .frame(height: 200)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }

                    // Average Feeling Score
                    Group {
                        Text("Average Feeling Score")
                            .font(.headline)
                        Chart {
                            LineMark(
                                x: .value("Date", "July 1"),
                                y: .value("Feeling", 3)
                            )
                            LineMark(
                                x: .value("Date", "July 2"),
                                y: .value("Feeling", 4)
                            )
                            LineMark(
                                x: .value("Date", "July 3"),
                                y: .value("Feeling", 2)
                            )
                        }
                        .frame(height: 200)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }

                    // Additional Statistics can be added here
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("Statistics", displayMode: .inline)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
