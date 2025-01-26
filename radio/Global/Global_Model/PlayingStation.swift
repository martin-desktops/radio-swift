//
//  PlayingStation.swift
//  Radio
//
//  Created by Marcin Wolski on 06/10/2023.
//

import Foundation
import SwiftUI
import SwiftData
import Observation
import OSLog

@Observable
class PlayingStation {
    
    static let shared = PlayingStation()
    
    var currentlyPlayingRichStation: RichStation?
    
    init() {
        Task {
            await setCurrentlyPlayingRichStationFromCache()
        }
    }
    
    @MainActor
    func setCurrentlyPlayingRichStationFromCache() async {
        do {
            let cachedRichStations = try  Persistance.shared.container.mainContext.fetch(FetchDescriptor<RichStation>())
            for cachedRichStation in cachedRichStations {
                if cachedRichStation.currentlyPlaying {
                    currentlyPlayingRichStation = cachedRichStation
                    break
                }
                if currentlyPlayingRichStation == nil {
                    Logger.playingStationManager.notice("There was no played cached stations")
                } else {
                    self.currentlyPlayingRichStation = nil
                }
            }
        } catch {
            self.currentlyPlayingRichStation = nil
        }
    }
    
    @MainActor
    func persistRichStation(richStation: RichStation) async {
        Logger.playingStationManager.info("Trying to persist a station")
        Persistance.shared.container.mainContext.insert(richStation)
        if Persistance.shared.container.mainContext.hasChanges {
            do {
                try Persistance.shared.container.mainContext.save()
                Logger.playingStationManager.info("Persisted \(richStation.stationBase.name)")
            } catch {
                fatalError("Cannot cache \(richStation.stationBase.name)")
            }
        }
    }
    
    func setCurrentlyPlayingRichStation(_ richStation: RichStation) async {
        if currentlyPlayingRichStation != richStation {
            await persistRichStation(richStation: richStation)
            await MainActor.run {
                Logger.playingStationManager.info("Chaning currentlyPlaying item")
                currentlyPlayingRichStation?.currentlyPlaying = false
                currentlyPlayingRichStation = nil
                richStation.currentlyPlaying = true
                currentlyPlayingRichStation = richStation
                Task {
                    await richStation.setFavicon(richStation.faviconData)
                }
                
                Logger.playingStationManager.info("PlayingStation has been replaced by \(richStation.stationBase.name)")
            }
        } else {
            Logger.playingStationManager.notice("No need to replace PlayingStation")
        }
    }
    
}







