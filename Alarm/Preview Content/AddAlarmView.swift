import SwiftUI
import AVFoundation
import SwiftData

struct AddAlarmView: View {
    @Environment(\.modelContext) var modelContext
    @Query var alarms: [Alarm]
    @State private var alarm: Bool = false
    @State private var labelPickerSelected: String = ""
    @State private var RepeatPickerSelected: String = ""
    @State private var timeSelected: String = ""
    @State private var snoozeSelected: Bool = false
    @State private var soundDataSelected: String = ""
    @State private var noteSelected: String = ""
    @State private var isEnabledToggle: Bool = true
    @State private var dateSelected: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var alarmData: ((_ alarmData: Alarm) -> Void)
    let repeatData = ["Every Monday","Every Tuesday","Every Wednesday","Every Thursday","Every Friday","Every Saturday","Every Sunday","Never"]
    let soundName = ["AudioServicesPlaySystemSound(1003)","AudioServicesPlaySystemSound(1004)","AudioServicesPlaySystemSound(1005)","AudioServicesPlaySystemSound(1006)","AudioServicesPlaySystemSound(1007)","AudioServicesPlaySystemSound(1519)"]
    
    var body: some View {
        
        NavigationStack {
            VStack {
                topNavbar()
                
                Form {
                    addTime()
                    
                    addRepeatOption()
                    
                    addTextLabel()
                    
                    addSoundOption()
                    
                    addSnoozeToggle()
                }
            }
        }
    }
    
    fileprivate func topNavbar() -> HStack<TupleView<(some View, Spacer, Text, Spacer, some View)>> {
        return HStack {
            Button("Cancel", action: {
                presentationMode.wrappedValue.dismiss()
            }).padding()
                .foregroundColor(.orange)
            Spacer()
            Text("Add Alarm")
                .font(.title2)
                .bold()
            Spacer()
            Button("Save", action: {
                alarmData(collectAlarmData())
                presentationMode.wrappedValue.dismiss()
                modelContext.insert(collectAlarmData())
            })
            .padding()
            .foregroundColor(.orange)
        }
    }
    
    fileprivate func addTime() -> some View {
        return DatePicker("", selection: $dateSelected, displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
    }
    
    fileprivate func addRepeatOption() -> some View {
        return Picker("Repeat", selection: $RepeatPickerSelected) {
            ForEach(repeatData, id: \.self) { option in
                Text(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func addSoundOption() -> some View {
        return Picker("Sound", selection: $soundDataSelected) {
            ForEach(soundName, id: \.self) { option in
                Text(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func addTextLabel() -> HStack<TupleView<(Text, Spacer, some View)>> {
        return HStack {
            Text("Label")
            Spacer()
            TextField("Alarm", text: $noteSelected)
                .textFieldStyle(.plain)
                .textInputAutocapitalization(.never)
                .padding(.leading,120)
                .disableAutocorrection(true)
        }
    }
    
    fileprivate func addSnoozeToggle() -> Toggle<Text> {
        return Toggle(isOn: $isEnabledToggle) {
            Text("Snooze")
        }
    }
    
    private func collectAlarmData() -> Alarm {
        return Alarm(
            time: formatTime(dateSelected),
            repeatOption: RepeatPickerSelected,
            note: noteSelected,
            sound: soundDataSelected ,
            isEnabled: isEnabledToggle
        )
    }
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    AddAlarmView { alarmData in
        
    }
}
