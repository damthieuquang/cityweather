//
//  City.swift
//  CWModels
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation
import RealmSwift

// MARK: - City
public struct City: Codable, Identifiable, Hashable {
  public let coordinate: Coordinate?
  public let weather: [Weather]?
  public let base: String?
  public let main: Main?
  public let visibility: Int?
  public let wind: Wind?
  public let clouds: Clouds?
  public let timeData: Int?
  public let sys: Sys?
  public let timezone, id: Int?
  public let name: String
  public let cod: Int? // Already optional, good
  public var isFavourite: Bool = false

  enum CodingKeys: String, CodingKey {
    case coord, weather, base, main, visibility
    case wind, clouds, sys, timezone, id, name, cod
    case timeData = "dt"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.coordinate = try container.decodeIfPresent(Coordinate.self, forKey: .coord)
    self.weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
    self.base = try container.decodeIfPresent(String.self, forKey: .base)
    self.main = try container.decodeIfPresent(Main.self, forKey: .main)
    self.visibility = try container.decode(Int.self, forKey: .visibility)
    self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
    self.clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds)
    self.timeData = try container.decode(Int.self, forKey: .timeData)
    self.sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
    self.timezone = try container.decode(Int.self, forKey: .timezone)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.cod = try container.decode(Int.self, forKey: .cod)
  }

  init(
    coordinate: Coordinate?,
    weather: [Weather]?,
    base: String?,
    main: Main?,
    visibility: Int?,
    wind: Wind?,
    clouds: Clouds?,
    timeData: Int?,
    sys: Sys?,
    timezone: Int?, id: Int?, name: String, cod: Int?, isFavourite: Bool = false
  ) {
    self.coordinate = coordinate
    self.weather = weather
    self.base = base
    self.main = main
    self.visibility = visibility
    self.wind = wind
    self.clouds = clouds
    self.timeData = timeData
    self.sys = sys
    self.timezone = timezone
    self.id = id
    self.name = name
    self.cod = cod
    self.isFavourite = isFavourite
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(coordinate, forKey: .coord)
    try container.encode(weather, forKey: .weather)
    try container.encode(base, forKey: .base)
    try container.encode(main, forKey: .main)
    try container.encode(visibility, forKey: .visibility)
    try container.encode(wind, forKey: .wind)
    try container.encode(clouds, forKey: .clouds)
    try container.encode(timeData, forKey: .timeData)
    try container.encode(sys, forKey: .sys)
    try container.encode(timezone, forKey: .timezone)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(cod, forKey: .cod)
  }

  public static func == (lhs: City, rhs: City) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
  }

  public func toObject() -> CityRealmObject {
    let cityRealmObject = CityRealmObject()
    cityRealmObject.id = id ?? 0
    cityRealmObject.name = name
    cityRealmObject.country = sys?.country ?? ""
    cityRealmObject.isFavourite = isFavourite

    cityRealmObject.weather.append(objectsIn: weather?.compactMap { weather in
      let weatherRealmObject = WeatherRealmObject()
      weatherRealmObject.id = weather.id
      weatherRealmObject.main = weather.main
      weatherRealmObject.desc = weather.description
      weatherRealmObject.icon = weather.icon
      return weatherRealmObject
    } ?? [])

    if let main = main {
      cityRealmObject.main = MainRealmObject()
      cityRealmObject.main?.temp = main.temp
      cityRealmObject.main?.feelsLike = main.feelsLike
      cityRealmObject.main?.tempMin = main.tempMin
      cityRealmObject.main?.tempMax = main.tempMax
      cityRealmObject.main?.pressure = main.pressure
      cityRealmObject.main?.humidity = main.humidity
      cityRealmObject.main?.seaLevel = main.seaLevel
      cityRealmObject.main?.grndLevel = main.grndLevel
    }

    if let wind = wind {
      cityRealmObject.wind = WindRealmObject()
      cityRealmObject.wind?.speed = wind.speed
      cityRealmObject.wind?.deg = wind.deg
      cityRealmObject.wind?.gust = wind.gust
    }

    if let clouds = clouds {
      cityRealmObject.clouds = CloudsRealmObject()
      cityRealmObject.clouds?.all = clouds.all
    }

    return cityRealmObject
  }

}

// MARK: - Clouds
public struct Clouds: Codable, Hashable {
  public let all: Int
}

// MARK: - Coordinate
public struct Coordinate: Codable, Hashable {
  public let lon, lat: Double
}

// MARK: - Main
public struct Main: Codable, Hashable {
  public let temp, feelsLike, tempMin, tempMax: Double
  public let pressure, humidity, seaLevel, grndLevel: Int

  enum CodingKeys: String, CodingKey {
    case temp, pressure, humidity
    case seaLevel = "sea_level"
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case grndLevel = "grnd_level"
    case tempMax = "temp_max"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.temp = try container.decodeIfPresent(Double.self, forKey: .temp) ?? 0
    self.feelsLike = try container.decodeIfPresent(Double.self, forKey: .feelsLike) ?? 0
    self.tempMin = try container.decodeIfPresent(Double.self, forKey: .tempMin) ?? 0
    self.tempMax = try container.decodeIfPresent(Double.self, forKey: .tempMax) ?? 0
    self.pressure = try container.decodeIfPresent(Int.self, forKey: .pressure) ?? 0
    self.humidity = try container.decodeIfPresent(Int.self, forKey: .humidity) ?? 0
    self.seaLevel = try container.decodeIfPresent(Int.self, forKey: .seaLevel) ?? 0
    self.grndLevel = try container.decodeIfPresent(Int.self, forKey: .grndLevel) ?? 0
  }

  public init(temp: Double, feelsLike: Double, tempMin: Double,
              tempMax: Double, pressure: Int, humidity: Int, seaLevel: Int,
              grndLevel: Int) {
    self.temp = temp
    self.feelsLike = feelsLike
    self.tempMin = tempMin
    self.tempMax = tempMax
    self.pressure = pressure
    self.humidity = humidity
    self.seaLevel = seaLevel
    self.grndLevel = grndLevel
  }
}

// MARK: - Sys
public struct Sys: Codable, Hashable {
  public let type, id: Int
  public let country: String
  public let sunrise, sunset: TimeInterval

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
    self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
    self.sunrise = try container.decodeIfPresent(TimeInterval.self, forKey: .sunrise) ?? 0
    self.sunset = try container.decodeIfPresent(TimeInterval.self, forKey: .sunset) ?? 0
  }

  public init(type: Int, id: Int, country: String, sunrise: TimeInterval, sunset: TimeInterval) {
    self.type = type
    self.id = id
    self.country = country
    self.sunrise = sunrise
    self.sunset = sunset
  }
}

// MARK: - Weather
public struct Weather: Codable, Hashable {
  public let id: Int
  public let main, description, icon: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
    self.main = try container.decodeIfPresent(String.self, forKey: .main) ?? ""
    self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    self.icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? ""
  }

  public init(id: Int, main: String, description: String, icon: String) {
    self.id = id
    self.main = main
    self.description = description
    self.icon = icon
  }
}

// MARK: - Wind
public struct Wind: Codable, Hashable {
  public let speed: Double
  public let deg: Int
  public let gust: Double

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.speed = try container.decodeIfPresent(Double.self, forKey: .speed) ?? 0
    self.deg = try container.decodeIfPresent(Int.self, forKey: .deg) ?? 0
    self.gust = try container.decodeIfPresent(Double.self, forKey: .gust) ?? 0
  }

  public init(speed: Double, deg: Int, gust: Double) {
    self.speed = speed
    self.deg = deg
    self.gust = gust
  }
}
