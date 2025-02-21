//
//  AlarmApp.swift
//  Alarm
//
//  Created by Ahsan Aqeel on 17/02/2025.
//
import SwiftData
import SwiftUI

@main
struct AlarmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Alarm.self)
    }
}
