//
//  SearchViewViewModel.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation
import CWServices
import CWModels

final class SearchViewViewModel: ObservableObject {
  private var serviceManager = ServiceManager.shared
  @Published var cities: [City] = []
  
  func getCityByName(cityName: String)
  {
    serviceManager.getCityByName(cityName: cityName) { city, error in
      if error != nil {
        print("Error: \(String(describing: error))")
        return
      }
      if let city = city {
        DispatchQueue.main.async {
          self.cities.append(city)
        }
      }
    }
  }
}
