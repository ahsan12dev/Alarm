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
