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
  @Published var loadingState: LoadingState = .none
  @Published var cities: [City] = []
  
  func getCityByName(cityName: String) {
    DispatchQueue.main.async {
      self.loadingState = .loading
    }
    serviceManager.getCityByName(cityName: cityName) { [weak self] city, error in
      DispatchQueue.main.async {
        if let error = error {
          print("Error: \(error)")
          self?.loadingState = .failed
          return
        }
        if let city = city {
          self?.loadingState = .success
          self?.cities.append(city)
        }
      }
    }
  }
}
