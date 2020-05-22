//
//  ContentView.swift
//  RecordAudio
//
//  Created by Kevin Gorjanc on 4/29/20.
//  Copyright © 2020 seekAndCreate. All rights reserved.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @State var fileURL = try? FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
    
    @State var isPaused = false
    
    var body: some View {
        
//
//       NavigationView {
//            Text("Hello, World!")
//                .navigationBarTitle("Navigation")
//        }
        VStack{
       
            Text("noteToSelf").font(.system(size: 24.0, weight: .bold)).padding(15.0)
            HStack{
                Spacer()
                if audioRecorder.currentlyRecording {
                    if isPaused {
                         Button(action: {
                            print("resume")
                            self.audioRecorder.resumeRecording()
                            self.isPaused.toggle()
                        }) {
                            Image(systemName: "arrow.uturn.right") .font(.system(size: 36.0))
                            Image(systemName: "mic.fill") .font(.system(size: 36.0))
                            }
                        } else {
                        Button(action: {
                            print("pause button pressed")
                            self.audioRecorder.pauseRecording()
                            self.isPaused.toggle()
                            }) {
                                Image(systemName: "pause.fill") .font(.system(size: 48.0))
                        }
                    }
                } else {
                    Button(action: {
                    print("START REC button")
                    self.audioRecorder.currentlyRecording.toggle()
                    self.audioRecorder.recordTapped()
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 48.0))
                    }
                    }
            Spacer()
            Button(action: {
                print("buttonstop")
                if self.audioRecorder.currentlyRecording {
                self.audioRecorder.currentlyRecording.toggle()
                self.audioRecorder.finishRecording()
                self.fileURL = try! FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
                } else {
                    
                }
                }) {
                    Image(systemName: "square.fill")
                        .font(.system(size: 48.0))
                }
                
                Spacer()
            }.buttonStyle(BorderlessButtonStyle())
                .padding(30.0)
            
            List(0 ..< self.fileURL!.count, id: \.self){ item in
                HStack{
                     Button(action: {
                         self.audioPlayer.maybePlayAudio(audioFileIndex:item)
                         print(self.fileURL![item].absoluteString)
                     })
                         {
                             Text("\(self.fileURL!  [item].lastPathComponent)").foregroundColor(.gray)
                         }
                     Spacer()
                     Button(action: {
                         print("delete this file")
                         self.deleteRecordingInDirectory(fileIndex: item)
                     })
                         {
                             Image(systemName:"trash").foregroundColor(.red)
                     }
                }
            }.buttonStyle(BorderlessButtonStyle())
          
            }.onAppear {
                self.audioPlayer.getCacheDirectory()
                self.audioRecorder.setupAudioRecorder()
            }
    }

    
   
    func deleteRecordingInDirectory(fileIndex: Int){
        let fileManager = FileManager.default
//        let myURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[fileIndex]
        do {
            try fileManager.removeItem(at: self.fileURL![fileIndex])
        } catch {
        
        }
         self.fileURL = try! FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)    
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
