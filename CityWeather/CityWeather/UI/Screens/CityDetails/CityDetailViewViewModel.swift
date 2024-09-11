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
  private var realmService = RealmService()
  
  init(city: City) {
    self.city = city
    // load city from realm
    let cities = realmService.getCities()
    if let existedCity = cities.first(where: { $0.id == city.id }) {
      // update city to realm
      self.city.isFavourite = existedCity.isFavourite
      realmService.updateCity(city: self.city)
    }
  }
  
  func toggleFavorite() {
    city.isFavourite.toggle()
    if city.isFavourite {
      self.city.isFavourite = true
      realmService.updateCity(city: city)
    } else {
      self.city.isFavourite = false
      realmService.deleteCity(city: city)
    }
  }
}
