//
//  FavouriteViewViewModel.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation
import CWModels

final class FavoriteViewViewModel: ObservableObject {
  @Published var cities: [City] = []
  
  private let realmService = RealmService()
  
  var navigationTitle: String { "Favourite" }
  var emptyStateMessage: String { "You have no favorite cities" }
  var removeButtonLabel: String { "Remove" }
  
  init() {
    loadCities()
  }
  
  func toggleFavorite(city: City) async {
    if cities.contains(city) {
      realmService.deleteCity(city: city)
    } else {
      realmService.addCity(city: city)
    }
  }
  
  func loadCities() {
    let cities = realmService.getCities()
    self.cities = cities
  }
  
  func deleteCity(city: City) {
    realmService.deleteCity(city: city)
  }
  
  func updateCity(city: City) {
    realmService.updateCity(city: city)
  }
}
