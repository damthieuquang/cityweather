//
//  SearchViewViewModel.swift
//  CityWeather
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation
import CWServices
import CWModels

protocol CitySearching {
  func getCityByName(cityName: String,
                     completion: @escaping (_ city: City?, _ error: String?) -> Void)
}

extension ServiceManager: CitySearching {}

final class SearchViewViewModel: ObservableObject {
  private let citySearcher: CitySearching
  @Published var loadingState: LoadingState = .none
  @Published var history: [City] = []

  init(citySearcher: CitySearching = ServiceManager.shared) {
    self.citySearcher = citySearcher
  }

  func getCityByName(cityName: String) {
    DispatchQueue.main.async {
      self.loadingState = .loading
    }
    citySearcher.getCityByName(cityName: cityName) { [weak self] city, error in
      DispatchQueue.main.async {
        if let error = error {
          print("Error: \(error)")
          self?.loadingState = .failed
          return
        }
        if let city = city {
          self?.loadingState = .success
          self?.shouldAddHistory(city: city)
        }
      }
    }
  }
  
  func deleteHistory(city: City) {
    history.removeAll(where: { $0 == city })
  }
  
  private func shouldAddHistory(city: City) {
    if history.contains(city) {
      history.removeAll(where: { $0 == city })
      history.insert(city, at: 0)
    }
    else {
      history.insert(city, at: 0)
    }
  }
}
