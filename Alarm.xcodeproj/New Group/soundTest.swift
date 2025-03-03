//
//  soundTest.swift
//  
//
//  Created by Ahsan Aqeel on 26/02/2025.
//

//import SwiftUI
//import AVFoundation
//
//struct SoundTestView: View {
//
//    @State var player: AVAudioPlayer?
//
//    func playSound(soundName: String, soundVol: Float ) {
//
//        guard let path = Bundle.main.path(forResource: soundName, ofType: nil ) else {
//            print("path not created")
//            return
//        }
//
//        let url = URL(fileURLWithPath: path)
//        //This will work if you don't use guard
//        //let url = URL(fileURLWithPath: path!)
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.volume = soundVol
//            player?.play()
//        } catch {
//            print("Error playing sound: \(error.localizedDescription)")
//        }
//    }
//
//    var body: some View {
//
//        Button("Play the Beep Sound") {
//
//            playSound(soundName: "silent_hill.mp3", soundVol: 0.1) // Call function to play sound
//
//        }
//        .padding(10)
//        .buttonStyle(.bordered)
//        .font(.largeTitle)
//        .foregroundStyle(.yellow)
//        .background(.blue)
//        .cornerRadius(25)
//
//        Button("Play the Click Sound") {
//
//            playSound(soundName: "iphone_alarm.mp3", soundVol: 0.5) // Call function to play sound
//
//        }
//        .padding(10)
//        .buttonStyle(.bordered)
//        .font(.largeTitle)
//        .foregroundStyle(.blue)
//        .background(.yellow)
//        .cornerRadius(25)
//
//        Button("Play Ding-Dong Sound") {
//
//            playSound(soundName: "iphone_best_alarm.mp3", soundVol: 0.1) // Call function to play sound
//
//        }
//        .padding(10)
//        .buttonStyle(.bordered)
//        .font(.largeTitle)
//        .foregroundStyle(.white)
//        .background(.gray)
//        .cornerRadius(25)
//
//    }
//}
//
//#Preview {
//    SoundTestView()
//}
