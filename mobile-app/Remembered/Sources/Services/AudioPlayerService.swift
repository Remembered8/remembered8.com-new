import Foundation
import AVFoundation

/// Audio Player service for Oral History & Voice Recordings
@MainActor
public final class AudioPlayerService: NSObject, ObservableObject {
    public static let shared = AudioPlayerService()
    
    @Published public private(set) var isPlaying: Bool = false
    @Published public private(set) var currentStoryId: String? = nil
    @Published public private(set) var currentTime: TimeInterval = 0
    @Published public private(set) var duration: TimeInterval = 0
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    public override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    public func play(storyId: String, url: URL) {
        if currentStoryId == storyId, let player = player {
            if isPlaying {
                player.pause()
                isPlaying = false
            } else {
                player.play()
                isPlaying = true
            }
            return
        }
        
        stop()
        currentStoryId = storyId
        let item = AVPlayerItem(url: url)
        let newPlayer = AVPlayer(playerItem: item)
        self.player = newPlayer
        
        newPlayer.play()
        isPlaying = true
        
        timeObserver = newPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
            if let dur = newPlayer.currentItem?.duration.seconds, !dur.isNaN {
                self?.duration = dur
            }
        }
    }
    
    public func stop() {
        player?.pause()
        if let obs = timeObserver {
            player?.removeTimeObserver(obs)
            timeObserver = nil
        }
        player = nil
        isPlaying = false
        currentStoryId = nil
        currentTime = 0
        duration = 0
    }
}
