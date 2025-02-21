import SwiftUI
import AVFoundation
import SwiftData


struct EditAlarmView: View {
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
    @State private var noteSel: String = ""
    @State private var timeSel: String = ""
    @State private var labelSel: String = ""
    @State private var soundSel: String = ""
    @State private var repeatSel: String = ""
    @State private var dateSelected: Date = Date()
    @State private var cancelButtonTapped: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
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
   
    func populateData() {
     //   dateSelected = alarmObj.time
        
       // dateSelected = alarmObj.time
        timeSelected = alarmObj.time

        noteSelected = alarmObj.note
        RepeatPickerSelected = alarmObj.repeatOption
        soundDataSelected = alarmObj.sound
        snoozeSelected = alarmObj.isEnabled
        print(noteSelected)
        print(RepeatPickerSelected)
        print(soundDataSelected)
        print(timeSelected)
        print(isEnabled)
    }
    
    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMM dd yyyy h:mm a"

         return convertDateFormatter.string(from: oldDate!)
    }
    
    
    fileprivate func Header() -> HStack<TupleView<(some View, Spacer, Text, Spacer, some View)>> {
        return HStack {
            Button("Cancel", action: {
                cancelButtonTapped = true
                presentationMode.wrappedValue.dismiss()
            })
            .foregroundColor(.orange)
            
            Spacer()
            
            Text("Edit Alarm \(alarmObj.time)")
                .font(.title2)
                .bold()
            
            
            Spacer()
            
            Button("Update", action: {
             //   alarmData(collectAlarmData())
                presentationMode.wrappedValue.dismiss()
                modelContext.insert(collectAlarmData())
                
            })
           
        }
    }
//    private func delete(folder: Alarm) {
//           if let context = folder.modelContext {
//             context.delete(folder)
//           }
//        }
    
    private func delete(folder: Alarm) {
        modelContext.delete(folder)
    }
    var alarmObj: Alarm
    init(alarmObj: Alarm) {
        self.alarmObj = alarmObj
    }
    var id: UUID = UUID()
    var body: some View {
        
        NavigationStack {
           
            VStack {
                Header()
                    .padding()
                
                Form {
                    
                    DatePicker("Time", selection: $timeSelected, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                    
                    Repeat()
                    
                    Label()
                    
                    Sound()
                    
                    Toggle(isOn: $isEnabled) {
                        Text("Snooze")
                    }
                    
//                    Button("Delete \(alarmObj.id)", action: {
//                        delete(folder: alarmObj)
//                        presentationMode.wrappedValue.dismiss()
//                    })
                    Button("Populate ",action: {
                        populateData()
                    })
//                    Button("Repeat \(alarmObj.repeatOption)",action: {
//                      //  populateData()
//                     
//                    })
                    
                }
                
                
              }
            }
        }
    }



#Preview {
    EditAlarmView(alarmObj: .init(time: "", repeatOption: "", note: "", sound: "", isEnabled: true)) 
}
