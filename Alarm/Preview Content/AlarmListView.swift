import SwiftUI
import SwiftData
import UserNotifications

struct AlarmListView: View {
    @State private var selectedAlarm: Alarm?
    @State private var selectedAlarmObj: Alarm?
    @State private var addAlarmSheet = false
    @Environment(\.modelContext) var modelContext
    @Query var alarms: [Alarm]
    
    var body: some View {
        TabView {
            Tab("World Clock", systemImage: "network") {
                Text("World Clock")
            }
            Tab("Alarm", systemImage: "alarm.fill") {
                VStack {
                    headerButtons()
                    topHeading()
                    alarmListView()
                }
            }
            Tab("StopWatch", systemImage: "stopwatch.fill") {
                Text("Stop Watch")
            }
            Tab("Timers", systemImage: "timer") {
                Text("Timers")
            }
        }
        .tabViewStyle(.tabBarOnly)
        .onAppear {
            requestNotificationPermission()
        }
    }
    
    fileprivate func headerButtons() -> some View {
        HStack {
            Button("Edit") {
                print("Edit clicked")
            }
            Spacer()
            Button("Add") {
                addAlarmSheet.toggle()
            }
            .sheet(isPresented: $addAlarmSheet) {
                AddAlarmView { alarmData in }
            }
            .presentationDetents([.large, .large])
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
    
    fileprivate func topHeading() -> some View {
        VStack(alignment: .leading) {
            Text("Alarms")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
        }
    }
    
    fileprivate func alarmListView() -> some View {
        NavigationView {
            List {
                Section(header: Text("Other")) {
                    ForEach(alarms, id: \.self) { alarm in
                        AlarmItemComponentView(alarm: alarm)
                            .background(Color.white)
                            .onTapGesture {
                                selectedAlarmObj = alarm
                            }
                            .onAppear {
                                checkAndTriggerNotification(for: alarm)
                            }
                    }
                }
                .padding(.vertical, -5)
            }
            .padding(.top, -30)
            .listStyle(PlainListStyle())
            .sheet(item: $selectedAlarmObj) { alarmObj in
                EditAlarmView(alarm: alarmObj)
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("✅ Notifications allowed.")
            } else {
                print("❌ Notifications denied.")
            }
        }
    }
    
    private func checkAndTriggerNotification(for alarm: Alarm) {
        let currentTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        
        if alarm.time == currentTime {
            let content = UNMutableNotificationContent()
            content.title = "⏰ Alarm!"
            content.subtitle = "Alarm time is reached, \(alarm.time) today!"
            content.body = "\(alarm.note)  \(alarm.repeatOption)"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            print("🔔 Alarm ringed at \(alarm.time)")
        }
    }
}

#Preview {
    AlarmListView()
}
