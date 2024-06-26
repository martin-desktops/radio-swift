//
//  LibraryView.swift
//  Radio
//
//  Created by Marcin Wolski on 06/10/2023.
//

import SwiftUI
import SwiftData
import OSLog

struct FavoriteContentView: View {
    @Query(filter: #Predicate<RichStation> { richStation in richStation.favourite } ) var favoriteRichStations: [RichStation]
    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationStack {
            Group {
                if favoriteRichStations.isEmpty {
                    NoStationsFavorited()
                } else {
                    ZStack(alignment: .top) {
                        PlayingBackground()
                        FavoriteView()
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) { SettingsView() }
            .navigationTitle("Favourite Stations")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "gear") { isShowingSettings = true }
                    if !networkMonitor.isConnected { NoInternetLabelView() }
                }
            }
            .onAppear {
                Logger.viewCycle.info("FavoriteContentView appeared")
            }
        }
    }
}
