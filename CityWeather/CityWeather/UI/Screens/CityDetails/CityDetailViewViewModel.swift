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
  var temperatureText: String {
    "\(Int(city.main?.temp ?? 0))°"
  }
  
  var feelsLikeTemperatureText: String {
    "Feels like \(Int(city.main?.feelsLike ?? 0))°"
  }
  
  var precipitationText: String {
    "\(Int(city.main?.humidity ?? 0))%"
  }
  
  var humidityValue: String {
    "\(Int(city.main?.humidity ?? 0))%"
  }
  
  var windSpeedText: String {
    guard let wind = city.wind else { return "" }
    return "\(Int(wind.speed)) km/h"
  }
  
  var coordinateText: String {
    guard let coord = city.coordinate else { return "" }
    return String(format: NSLocalizedString("Lat: %.2f, Lon: %.2f", comment: "Coordinate format"), coord.lat, coord.lon)
  }
  
  var cloudinessPercentText: String {
    guard let clouds = city.clouds else { return "" }
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
