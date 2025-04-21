struct RecordingRow: View {
    let recording: Recording
    let audioManager: AudioRecordingManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recording.filename ?? "Recording")
                    .font(.subheadline)
                
                if let date = recording.dateCreated {
                    Text(dateFormatter.string(from: date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {
                audioManager.playRecording(recording)
            }) {
                Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Button(action: {
                audioManager.deleteRecording(recording)
            }) {
                Image(systemName: "trash.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            .padding(.leading, 8)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
