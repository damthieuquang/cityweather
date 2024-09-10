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
  private let realmService = RealmService.shared
  
  init() {
    self.cities = mockData()
  }
  
  func mockData() -> [City] {
    return [
    ]
  }
  
  func toggleFavorite(city: City) async {
    do {
      if cities.contains(city) {
        try realmService.deleteCity(city: city)
      } else {
        try realmService.addCity(city: city)
      }
    } catch {
      print(error)
    }
  }
  
  func loadCities() async {
    do {
      let cities = try realmService.getCities()
      await MainActor.run {
        self.cities = cities
      }
    } catch {
      print(error)
    }
  }
  
  func addCity(city: City) async {
    do {
      try realmService.addCity(city: city)
    } catch {
      print(error)
    }
  }
  
  func deleteCity(city: City) async {
    do {
      try realmService.deleteCity(city: city)
    } catch {
      print(error)
    }
  }
  
  func updateCity(city: City) async {
    do {
      try realmService.updateCity(city: city)
    } catch {
      print(error)
    }
  }
}
