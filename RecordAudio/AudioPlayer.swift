//
//  AudioPlayer.swift
//  RecordAudio
//
//  Created by Kevin Gorjanc on 5/6/20.
//  Copyright © 2020 seekAndCreate. All rights reserved.
//

import SwiftUI
import AVFoundation

class AudioPlayer : NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var currentlyPlaying = false

//    var audioPlayer: AVAudioPlayer
//    @State var fileURL: [URL] = []

    func getCacheDirectory() -> [URL] {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
   //     do {
            let fileURL = try? fileManager.contentsOfDirectory(at: documentsURL[0], includingPropertiesForKeys: nil)
            print(fileURL ?? [])
            return fileURL ?? []
//        } catch {
//            print("error while enumerating files TO fileurl")
//        }
    }
    
    func maybePlayAudio(audioFileIndex: Int){
        do {
            print("maybe play audio function")
            print(audioFileIndex)
            print(getCacheDirectory()[audioFileIndex])
            let audioPlayer = try AVAudioPlayer(contentsOf: getCacheDirectory()[audioFileIndex])
          
            audioPlayer.volume = 1.0
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            while audioPlayer.isPlaying {
                print(audioPlayer.isPlaying)
            }
           
        } catch {
            print("error configuring audio")
        }
    }
    
    
}

struct AudioPlayer_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

