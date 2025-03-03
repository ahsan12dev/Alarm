import SwiftUI
import SwiftData
import AVFoundation
import UserNotifications

struct AlarmListView: View {
    @State private var isEnabled = false
    @State private var selectedAlarm: Alarm?
    @State private var currenttime: String = ""
    @State private var alarmsTime: String = ""
    @State private var notification: Bool = false
    @Environment(\.modelContext) var modelContext
    @Query var alarms: [Alarm]
    @State var selectedAlarmObj: Alarm?
    @State private var addAlarmSheet = false
    
    var body: some View {
        TabView {
            Tab("World Clock", systemImage: "network") {
                Text("World Clock")
            }
            Tab("Alarm", systemImage: "alarm.fill") {
                HStack {
                    Button("Edit"){
                        print("Edit clicked")
                    }
                    Spacer()
                    Button("Add") {
                        addAlarmSheet.toggle()
                    }
                    .sheet(isPresented: $addAlarmSheet) {
                        AddAlarmView{
                            alarmData in
                        }
                    }
                    .presentationDetents([.large, .large])
                    .sheet(item: $selectedAlarm) { alarm in
                        EditAlarmView(alarm: alarm)
                    }
                }.padding(.horizontal)
                headerView()
                AlarmlistView()
            }
            Tab("StopWatch", systemImage: "stopwatch.fill") {
                Text("Stop Watch")
            }
            Tab("Timers", systemImage: "timer") {
                Text("Timers")
            }
        }.tabViewStyle(.tabBarOnly)
    }
    
    fileprivate func topNavBarView() -> some View {
        return HStack {
            VStack(spacing: 5){
                Button("Edit",action: {
                    print("Edit clicked")
                })
            }
            Spacer()
            NavigationLink(destination: AddAlarmView { alarmData in
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            }
        }.padding(.horizontal)
    }
    
    fileprivate func headerView() -> VStack<some View> {
        return VStack(alignment: .leading) {
            Text("Alarms")
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 30, alignment: .top)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal,10)
                .padding(.bottom)
        }
    }
    
    fileprivate func AlarmlistView() -> NavigationView<some View> {
        return NavigationView {
            List {
                Section(header: Text("Other")) {
                    ForEach(alarms.indices, id: \.self) { index in
                        AlarmItemComponentView(
                            time: alarms[index].time,
                            note: alarms[index].note + " " + alarms[index].repeatOption,
                            isEnabled: alarms[index].isEnabled
                        )
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .onTapGesture {
                            selectedAlarmObj = alarms[index]
                        }
                        .onAppear(){
                            currenttime = DateFormatter.localizedString(from: Date() , dateStyle: .none, timeStyle: .short)
                            alarmsTime = alarms[index].time
                            if alarmsTime == currenttime
                            {
                                let content = UNMutableNotificationContent()
                                content.title = "⏰ Alarm!"
                                content.subtitle = "Alarm time is reached , \(alarms[index].time) today!"
                                content.body = "\(alarms[index].note)  \(alarms[index].repeatOption)"
                                content.sound = UNNotificationSound.default
                                
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request)
                                
                                print("Ringed")
                            } else {
                                print("No Alarm At This Time")
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .sheet(item: $selectedAlarmObj) { alarmObj in
                EditAlarmView(alarm: alarmObj)
            }
        }
    }
}

#Preview {
    AlarmListView()
}

