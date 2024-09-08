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
  
  init() {
    self.cities = mockData()
  }
  
  func mockData() -> [City] {
    return [
      
    ]
  }
  
  func deleteFavoriteCity(at indexSet: IndexSet) {
    cities.remove(atOffsets: indexSet)
  }
}
