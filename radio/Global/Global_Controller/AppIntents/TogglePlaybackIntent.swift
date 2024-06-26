//
//  togglePlaybackIntent.swift
//  Radio
//
//  Created by Marcin Wolski on 26/11/2023.
//

import Foundation
import AppIntents
import SwiftData

struct TogglePlayback: AppIntent {
    
    static var title: LocalizedStringResource = "Toggle Playback"
    static var description: IntentDescription? = "Toggles the playback"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        if PlayerState.shared.firstPlay == true {
            guard let currentlyPlayingRichStation = PlayingStation.shared.currentlyPlayingRichStation else { return .result()}
            await AudioController.shared.playRichStation(currentlyPlayingRichStation)
        } else {
             AudioController.shared.togglePlayback()
        }
        return .result()
    }
    
}
