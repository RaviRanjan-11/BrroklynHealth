//
//  AudioRecordingManager.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 21/04/25.
//


import SwiftUI
import AVFoundation
import CoreData

class AudioRecordingManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    @Published var recordings: [AudioRecording] = []
    @Published var audioRecorder: AVAudioRecorder?
    @Published var audioPlayer: AVAudioPlayer?
    @Published var currentRecordingURL: URL?
    @Published var isPlaying = false
    
    private var context: NSManagedObjectContext
    private var patient: Patient?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func setPatient(_ patient: Patient) {
        self.patient = patient
        self.fetchRecordings()
    }
    
    func fetchRecordings() {
        guard let patient = patient else { return }
        
        let request: NSFetchRequest<AudioRecording> = AudioRecording.fetchRequest()
        request.predicate = NSPredicate(format: "patient == %@", patient)
        
        do {
            recordings = try context.fetch(request)
        } catch {
            print("Error fetching recordings: \(error.localizedDescription)")
        }
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            // Create unique file path
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let uniqueID = UUID().uuidString
            let audioFilename = documentPath.appendingPathComponent("\(uniqueID).m4a")
            
            // Recording settings
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            // Create and start recording
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            currentRecordingURL = audioFilename
            isRecording = true
            
        } catch {
            print("Failed to set up recording session: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        
        // Save recording to CoreData
        if let recordingURL = currentRecordingURL {
            saveRecording(url: recordingURL)
        }
    }
    
    func saveRecording(url: URL) {
        guard let patient = patient else { return }
        
        let newRecording = AudioRecording(context: context)
        newRecording.fileName = UUID().uuidString
        newRecording.fileUrl = url.path
        newRecording.id = UUID()
        newRecording.patient = patient
        newRecording.dateCreated = Date()
        
        do {
            try context.save()
            fetchRecordings()
        } catch {
            print("Failed to save recording: \(error.localizedDescription)")
        }
    }
    
    func playRecording(_ recording: AudioRecording) {
        guard let urlString = recording.fileUrl, let url = URL(string: "file://\(urlString)") else {
            print("Invalid recording URL")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play recording: \(error.localizedDescription)")
        }
    }
    
    func deleteRecording(_ recording: AudioRecording) {
        // Delete file from storage
        if let urlString = recording.fileUrl, let url = URL(string: "file://\(urlString)") {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Error deleting recording file: \(error.localizedDescription)")
            }
        }
        
        // Delete from CoreData
        context.delete(recording)
        
        do {
            try context.save()
            fetchRecordings()
        } catch {
            print("Error deleting recording from CoreData: \(error.localizedDescription)")
        }
    }
}


extension AudioRecordingManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
