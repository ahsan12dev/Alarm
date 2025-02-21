//
//  Alarm.swift
//  Alarm
//
//  Created by Ahsan Aqeel on 19/02/2025.
//

import Foundation
import SwiftData

@Model
class Alarm : Identifiable{
    
        let id = UUID()
          var time: String
        var repeatOption: String
        var note: String
        var sound: String
      //  var snooze: Bool
        var isEnabled: Bool
    
      //  var date: Date
   // var vibrate: Bool = false
    init(time: String, repeatOption: String, note: String, sound: String, isEnabled: Bool) {
        self.time = time
        self.repeatOption = repeatOption
        self.note = note
        self.sound = sound
      //  self.snooze = snooze
        self.isEnabled = isEnabled
    }
}
