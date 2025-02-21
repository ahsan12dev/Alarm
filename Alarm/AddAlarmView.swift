import SwiftUI
import AVFoundation
import SwiftData

//struct Alarm: Identifiable {
//    let id = UUID()
//    var time: String
//    var repeatOption: String
//    var note: String
//    var sound: String
//    var snooze: Bool
//    var isEnabled: Bool
//    
//  //  var date: Date
//}

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
   
    @State private var isEnabled: Bool = true
    @State private var dateSelected: Date = Date()
    @State private var cancelButtonTapped: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var alarmData: ((_ alarmData: Alarm) -> Void)
    
    let PickerData = ["Every Monday","Every Tuesday","Every Wednesday","Every Thursday","Every Friday","Every Saturday","Every Sunday","Never"]
    let soundName = ["Beacon", "Fireless", "DayDream", "Dew", "Weathering"]
    let soundData = ["AudioServicesPlaySystemSound(1003);","AudioServicesPlaySystemSound(1004)","AudioServicesPlaySystemSound(1005);","AudioServicesPlaySystemSound(1006);","AudioServicesPlaySystemSound(1007);","AudioServicesPlaySystemSound(1519);,"]
    let soundDataName = [""]

    private func collectAlarmData() -> Alarm {
        return Alarm(
            time: formatTime(dateSelected),
            repeatOption: RepeatPickerSelected,
            note: noteSelected,
            sound: soundDataSelected ,
           // snooze: snoozeSelected,
            isEnabled: isEnabled
            //  date: dateSelected
        )
    }
    

    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    fileprivate func Repeat() -> some View {
        return Picker("Repeat", selection: $RepeatPickerSelected) {
            ForEach(PickerData, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func Sound() -> some View {
        return Picker("Sound", selection: $soundDataSelected) {
            ForEach(soundData, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    fileprivate func Label() -> HStack<TupleView<(Text, Spacer, some View)>> {
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
    
    fileprivate func Header() -> HStack<TupleView<(some View, Spacer, Text, Spacer, some View)>> {
        return HStack {
            Button("Cancel", action: {
                cancelButtonTapped = true
                presentationMode.wrappedValue.dismiss()
            })
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
//            Button("Click",action: {
//               // modelContext.insert(Alarm.)
//            })
            .foregroundColor(.orange)
        }
    }
    
    var body: some View {
        
        
        NavigationStack {
            VStack {
                Header()
                .padding()

                Form {
                    DatePicker("Time", selection: $dateSelected, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())

                    Repeat() 

                    Label()

                    Sound()

                    Toggle(isOn: $isEnabled) {
                        Text("Snooze")
                    }
                }
            }
        }
    }
}

#Preview {
    AddAlarmView { alarmData in
        
    }
}
