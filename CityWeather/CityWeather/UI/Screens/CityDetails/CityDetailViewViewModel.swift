//
//  CityDetailViewViewModel.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation
import CWModels

final class CityDetailViewViewModel: ObservableObject {
  @Published var city: City
  private var realmService = RealmService.shared
  
  init(city: City) {
    self.city = city
    // load city from realm
    do {
      let cities = try realmService.getCities()
      if let existedCity = cities.first(where: { $0.id == city.id }) {
        // update city to realm
        self.city.isFavourite = existedCity.isFavourite
        try realmService.updateCity(city: self.city)
      }
    } catch {
      print(error)
    }
  }
  
  func toggleFavorite() {
    city.isFavourite.toggle()
    do {
      if city.isFavourite {
        self.city.isFavourite = true
        try realmService.updateCity(city: city)
      } else {
        self.city.isFavourite = false
        try realmService.updateCity(city: city)
      }
    } catch {
      print(error)
    }
  }
}
