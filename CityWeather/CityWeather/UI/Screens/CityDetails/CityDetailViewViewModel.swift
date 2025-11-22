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
  
  var country: String { "Country" }
  var sunrise: String { "Sunrise" }
  var sunset: String { "Sunset" }
  var timezone: String { "Timezone" }
  var cloudsText: String { "Clouds" }
  var cloudinessText: String { "Cloudiness" }
  var systemText: String { "System Info" }
  var nowText: String { "Now" }
  var hourlyForecastText: String { "Hourly Forecast" }
  var precipText: String { "Precip" }
  var humidityText: String { "Humidity" }
  var windText: String { "Wind" }
  var temperatureText: String? {
    guard let temp = city.main?.temp else { return nil }
    return "\(Int(temp))°"
  }

  var feelsLikeTemperatureText: String? {
    guard let feelsLike = city.main?.feelsLike else { return nil }
    return "Feels like \(Int(feelsLike))°"
  }

  var precipitationText: String? {
    guard let precipitation = city.main?.humidity else { return nil }
    return "\(precipitation)%"
  }

  var humidityValue: String? {
    guard let humidity = city.main?.humidity else { return nil }
    return "\(humidity)%"
  }

  var windSpeedText: String? {
    guard let wind = city.wind else { return nil }
    return "\(Int(wind.speed)) km/h"
  }

  var coordinateText: String? {
    guard let coord = city.coordinate else { return nil }
    return String(format: NSLocalizedString("Lat: %.2f, Lon: %.2f", comment: "Coordinate format"), coord.lat, coord.lon)
  }

  var cloudinessPercentText: String? {
    guard let clouds = city.clouds else { return nil }
    return "\(clouds.all)%"
  }
  
  init(city: City) {
    self.city = city
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
