//
//  SwiftUIView.swift
//  Alarm
//
//  Created by Ahsan Aqeel on 17/02/2025.
//

import SwiftUI
import SwiftData

//struct Alarm: Identifiable {
//    let id = UUID()
//    let time: String
//    var isEnabled: Bool
//    var note: String
//}
struct AlarmModel: Identifiable {
    let id = UUID()
    let time: String
    let note: String
    var isEnabled: Bool
}

struct AlarmListView: View {
    
    @State private var isEnabled = false
    
//    @State private var alarms: [Alarm] = [
//        
//    ]
    @Environment(\.modelContext) var modelContext
    @Query var alarms: [Alarm]
    @State var selectedAlarmObj: Alarm?

    
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
    
    
    
    fileprivate func listView() -> NavigationView<some View> {
        return NavigationView {
            List {
                Section(header: Text("Other")) {
                    ForEach(alarms.indices, id: \.self) { index in
                        AlarmItemComponentView(time: alarms[index].time, note: alarms[index].note + " " + alarms[index].repeatOption,
                                               isEnabled: .constant(true))
                        
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .onTapGesture {
                                selectedAlarmObj = alarms[index]
                                
                            }
                        
                    }
                }
                
               
            }
            
            .listStyle(PlainListStyle())
            .sheet(item: $selectedAlarmObj) { alarmObj in
                EditAlarmView(alarmObj: alarmObj)
            }
            
        }
    }
   

    @State private var showSheet = false
    @State private var showSheet2 = false
    var body: some View {
       
       
       
        TabView {
            Tab("World Clock", systemImage: "network") {
                
                Text("World Clock")
            }
            
            Tab("Alarm", systemImage: "alarm.fill") {
                
                 // topNavBarView()
                HStack {
                    Button("Edit"){
                       
                        print("Edit clicked")
                    }
                    Spacer()
                
                        Button("Add") {
                           
                            showSheet.toggle()
                        }
                        .sheet(isPresented: $showSheet) {
                            AddAlarmView { alarmData in
//                                alarms.append(alarmData)
                                
                            }
                                .presentationDetents([.large, .large])
                        }

                    
                }.padding(.horizontal)
               
               
                headerView()
                listView()
            }
          
            
            Tab("StopWatch", systemImage: "stopwatch.fill") {
                // AccountView()
                Text("Stop Watch")
            }
            // .badge("!")
            
            Tab("Timers", systemImage: "timer") {
                // AccountView()
                Text("Timers")
            }

        }.tabViewStyle(.tabBarOnly)
    }
    
}


#Preview {
    AlarmListView()
}

