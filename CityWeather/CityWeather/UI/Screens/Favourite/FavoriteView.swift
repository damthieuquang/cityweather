//
//  FavouriteView.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import SwiftUI
import CWModels

struct FavoriteView: View {
  @StateObject var viewModel = FavoriteViewViewModel()
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.cities, id: \.self) { city in
          NavigationLink(value: city) {
            Text(city.name)
          }
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
              Task {
                await viewModel.deleteCity(city: city)
              }
            } label: {
              Label("Remove", systemImage: "trash")
            }
          }
        }
      }
      .navigationDestination(for: City.self) { city in
        CityDetailView(city: city)
      }
      .navigationTitle("Favourite")
    }
  }
}

#Preview {
  FavoriteView()
}
