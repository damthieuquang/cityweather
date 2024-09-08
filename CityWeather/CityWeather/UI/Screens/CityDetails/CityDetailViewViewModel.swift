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

  init(city: City) {
    self.city = city
  }
}
