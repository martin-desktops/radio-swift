//
//  NoStationsFavorited.swift
//  Radio
//
//  Created by Marcin Wolski on 28/03/2024.
//

import Foundation
import SwiftUI

struct NoStationsFavorited: View {
    
    var body: some View {
        VStack {
            Spacer()
            ContentUnavailableView("Add Stations", systemImage: "magnifyingglass" , description: Text("You haven't favorited a station yet."))
            Spacer()
        }
    }
}

