import SwiftUI
import SwiftData
import OSLog

@Observable
class AudioController {
    
    static let shared = AudioController()
    
    var setupTask = Task { }
    
    func prepareStationBaseForPlayback(_ stationBase: StationBase) async {
        
        let richStation = RichStation(stationBase: stationBase, faviconData: nil)
        await playRichStation(richStation)
        Logger.audioController.notice("Preparing station finished.")
    }
    
    func playRichStation(_ richStation: RichStation) async {
        setupTask.cancel()
        setupTask = Task {
            
            
            await PlayingStation.shared.persistRichStation(richStation: richStation)
            await PlayingStation.shared.setCurrentlyPlayingRichStation(richStation)
            await MainActor.run { PlayerState.shared.playerStateSetup(richStation) }
            guard let url = URL(string: richStation.stationBase.url) else {
                await pause()
                return
            }
            // PLAY IT
            await AVAudioSessionController.shared.configureAudioSession()
            await AVPlayerController.shared.setupAVPlayerItem(url: url)
            await AVPlayerController.shared.play()
            // SETUP LOCKSCREEN
            await LockscreenController.shared.setupRemoteCommandCenterForLockScreenInput()
            await LockscreenController.shared.updateInfoCenterWithPlayingStation()
            
            
        }
    }
    
    func resume() async {
        await MainActor.run { PlayerState.shared.isPlaying = true }
        await AVPlayerController.shared.play()
        await AVAudioSessionController.shared.setActive(true)
    }
    
    func pause() async {
        await MainActor.run { PlayerState.shared.isPlaying = false }
        await AVPlayerController.shared.pause()
        await AVAudioSessionController.shared.setActive(false)
    }
    
    @MainActor func togglePlayback()   {
        Logger.audioController.info("Toggling the playback")
        if PlayerState.shared.isPlaying { Task { await pause() }}
        else { Task { await resume() }}
    }
}




