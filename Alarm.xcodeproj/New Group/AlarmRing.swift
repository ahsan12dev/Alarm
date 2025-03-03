//
//  AlarmRing.swift
//  
//
//  Created by Ahsan Aqeel on 26/02/2025.
//

import Foundation
//import AVFoundation
//
//class AudioPlayerViewModel: ObservableObject {
//  var audioPlayer: AVAudioPlayer?
//
//  @Published var isPlaying = false
//
//  init() {
//    if let sound = Bundle.main.path(forResource: "PocketCyclopsLvl1", ofType: "mp3") {
//      do {
//        self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
//      } catch {
//        print("AVAudioPlayer could not be instantiated.")
//      }
//    } else {
//      print("Audio file could not be found.")
//    }
//  }
//
//  func playOrPause() {
//    guard let player = audioPlayer else { return }
//
//    if player.isPlaying {
//      player.pause()
//      isPlaying = false
//    } else {
//      player.play()
//      isPlaying = true
//    }
//  }
//}
