//
//  AlarmItemComponentView.swift
//  Alarm
//
//  Created by Ahsan Aqeel on 17/02/2025.
//
import SwiftUI

struct AlarmItemComponentView: View {
    var time: String
    var note: String
    @Binding var isEnabled: Bool
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(time)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(note)
                    .font(.system(size: 14))
                    .fontWeight(.regular)
            }
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
            
            
        }
    }
}

#Preview {
    AlarmItemComponentView(time: "06:00 AM", note: "Meeting with the team", isEnabled: .constant(true))
}
