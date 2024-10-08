//
//  CountriesListView.swift
//  Radio
//
//  Created by Marcin Wolski on 09/12/2023.
//

import SwiftUI
import OSLog
struct CountriesView: View {
    @State var countriesModel = CountriesController.shared
    @Environment(StationsViewController.self) private var stationsModel: StationsViewController
    @State private var firstTime: Bool = true
    var body: some View {
        List {
            ForEach(countriesModel.searchableCountries, id: \.iso_3166_1) { country in
                NavigationLink  {
                    StationsOfCountryContentView(country: country)
                } label: {
                    CountryRow(country: country)
                }
            }
        }
        .searchable(text: $countriesModel.searchText, prompt: Text("Search for countries"))
        .disableAutocorrection(true)
        .contentMargins(.bottom, 96, for: .automatic)
    }
}
