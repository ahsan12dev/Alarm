import SwiftUI
import SwiftData

struct EditAlarmView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @State var alarm: Alarm
    @State private var dateSelected: Date = Date()
    @State private var noteSelected: String = ""
    @State private var snoozeSelected: Bool = false
    
    let PickerData = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday", "Every Sunday", "Never"]
    let soundName = ["AudioServicesPlaySystemSound(1003)","AudioServicesPlaySystemSound(1004)","AudioServicesPlaySystemSound(1005)","AudioServicesPlaySystemSound(1006)","AudioServicesPlaySystemSound(1007)","AudioServicesPlaySystemSound(1519)"]
    
    var body: some View {
        NavigationStack {
            
            topHeader()
            
            Form {
                editTime()
                
                editRepeat()
                
                editLabel()
                
                editSound ()
                
                editSnooze()
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
    
    fileprivate func topHeader() -> some View {
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
            }
            .foregroundColor(.orange)
        }
        .padding()
    }
    
    fileprivate func editTime() -> some View {
        return DatePicker("Time", selection: $dateSelected, displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
    }
    
    fileprivate func editRepeat() -> some View {
        return Picker("Repeat", selection: $alarm.repeatOption) {
            ForEach(PickerData, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func editLabel() -> HStack<TupleView<(Text, Spacer, some View)>> {
        return HStack {
            Text("Label")
            Spacer()
            TextField("Alarm", text: $alarm.note)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding(.leading,120)
        }
    }
    
    fileprivate func editSound() -> some View {
        return Picker("Sound", selection: $alarm.sound) {
            ForEach(soundName, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func editSnooze() -> Toggle<Text> {
        return Toggle(isOn: $snoozeSelected) {
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
        snoozeSelected = alarm.isEnabled
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
