import SwiftUI
import SwiftData

struct EditAlarmView: View {
    @State var alarm: Alarm
    @State private var dateSelected: Date = Date()
    @State private var noteSelected: String = ""
    @State private var soundSelected: String = ""
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    let PickerData = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday", "Every Sunday", "Never"]
    let soundName = ["AudioServicesPlaySystemSound(1003)","AudioServicesPlaySystemSound(1004)","AudioServicesPlaySystemSound(1005)","AudioServicesPlaySystemSound(1006)","AudioServicesPlaySystemSound(1007)","AudioServicesPlaySystemSound(1519)"]
    
    init(alarm: Alarm) {
        _alarm = State(initialValue: alarm)
        _dateSelected = State(initialValue: parseTime(alarm.time))
    }
    var body: some View {
        NavigationStack {
            
            topNavbar()
            
            Form {
                editTime()
                
                editRepeatOption()
                
                editTextLabel()
                
                editSoundOption()
                
                editSnoozeToggle()
                
                Button("Delete", action: {
                    deleteAlarm(folder: alarm)
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        .onAppear {
            populateAlarmData()
        }
    }
    
    fileprivate func topNavbar() -> some View {
        return HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.orange)
            Spacer()
            Text("Edit Alarm")
                .font(.title2)
                .bold()
            Spacer()
            Button("Save") {
                alarm.time = formatTime(dateSelected)
                try? modelContext.save()
                presentationMode.wrappedValue.dismiss()
                print("""
                        Alarm After Update: 
                        \(alarm.time) 
                        \(alarm.repeatOption) 
                        \(alarm.note) 
                        \(alarm.sound) 
                        \(alarm.isEnabled)
                        """)
            }
            .foregroundColor(.orange)
        }
        .padding()
    }
    
    fileprivate func editTime() -> some View {
        return DatePicker("", selection: $dateSelected, displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
    }
    
    fileprivate func editRepeatOption() -> some View {
        return Picker("Repeat", selection: $alarm.repeatOption) {
            ForEach(PickerData, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func editTextLabel() -> some View {
        return HStack {
            Text("Label")
            Spacer()
            TextField("Alarm", text: $alarm.note)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding(.leading,120)
        }
    }
    
    fileprivate func editSoundOption() -> some View {
        return Picker("Sound", selection: $alarm.sound) {
            ForEach(soundName, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func editSnoozeToggle() -> Toggle<Text> {
        return Toggle(isOn: $alarm.isEnabled) {
            Text("Snooze")
        }
    }
    
    private func deleteAlarm(folder: Alarm) {
        if let context = folder.modelContext {
            context.delete(folder)
        }
    }
    private func populateAlarmData() {
        dateSelected = parseTime(alarm.time)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    private func parseTime(_ time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.date(from: time) ?? Date()
    }
    
}
#Preview {
    EditAlarmView(alarm: Alarm(time: "", repeatOption: "", note: "", sound: "", isEnabled: true))
}
