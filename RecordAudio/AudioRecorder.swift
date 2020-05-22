//
//  AudioRecorder.swift
//  RecordAudio
//
//  Created by Kevin Gorjanc on 5/3/20.
//  Copyright © 2020 seekAndCreate. All rights reserved.
//

import SwiftUI
import AVFoundation

class AudioRecorder : NSObject, ObservableObject, AVAudioRecorderDelegate {
   
    @Published var currentlyRecording = false
    @Published var successfulRecording = false
    
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    
    
    func setupAudioRecorder(){
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { granted in
                       if granted {
                           print("audio permission granted")
                       } else {
                           print("audio permish was not granted")
                       }
                   }
        } catch {
            print("There was an error executing setupAudioRecorder")
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        print("get doucments func called")
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        let docDirectory = paths[0]
        return docDirectory
    }
    
    func getAudioURL() -> URL {
        print("get audioUrl called")
        let dateFormatter = DateFormatter()
        let dt = dateFormatter.date(from: "\(Date())")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        print(dateFormatter.string(from: dt ?? Date()))
        return getDocumentsDirectory().appendingPathComponent("\(dateFormatter.string(from: dt ?? Date())).m4a")
    }
    
    func startRecording() {
        print("startrecording()  called")
       
        let audioURL = getAudioURL()
        
        let audioSettings = [
                 AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                 AVSampleRateKey: 12000,
                 AVNumberOfChannelsKey: 1,
                 AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
             ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: audioSettings)
            audioRecorder.delegate = self
            audioRecorder.record()
            print("recording!")
        } catch {
            print("avaudiorecorder is not recording")
            finishRecording()
        }
    }
    
    func pauseRecording(){
        audioRecorder.pause()
        print("tried to pause, are we still recording? ---> \(audioRecorder.isRecording)")
    }
    
    func resumeRecording(){
        audioRecorder.record()
        print("tried to resumer recording, did it work? ---> \(audioRecorder.isRecording)")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorder didfinished recording")
        if flag == false {
            finishRecording()
        }
    }
    
    func finishRecording() {
        print(audioRecorder.isRecording)
        audioRecorder.stop()
        audioRecorder = nil
        print("Successful Recording")
        successfulRecording = true
    }

    
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
            self.successfulRecording = false
        } else {
           Alert(title: Text("Recording Error"), message: Text("There was a problem trying to start the recording, please try again!"), dismissButton: .default(Text("Return")))

        }
    }
}


struct AudioRecorder_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
