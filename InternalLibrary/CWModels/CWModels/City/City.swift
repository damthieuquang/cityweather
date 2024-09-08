//
//  City.swift
//  CWModels
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation

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
  public let name: String?
  public let cod: Int?

  enum CodingKeys: String, CodingKey {
    case coord, weather, base, main, visibility
    case wind, clouds, sys, timezone, id, name, cod
    case timeData = "dt"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.coordinate = try? container.decode(Coordinate.self, forKey: .coord)
    self.weather = try? container.decode([Weather].self, forKey: .weather)
    self.base = try? container.decode(String.self, forKey: .base)
    self.main = try? container.decode(Main.self, forKey: .main)
    self.visibility = try? container.decode(Int.self, forKey: .visibility)
    self.wind = try? container.decode(Wind.self, forKey: .wind)
    self.clouds = try? container.decode(Clouds.self, forKey: .clouds)
    self.timeData = try? container.decode(Int.self, forKey: .timeData)
    self.sys = try? container.decode(Sys.self, forKey: .sys)
    self.timezone = try? container.decode(Int.self, forKey: .timezone)
    self.id = try? container.decode(Int.self, forKey: .id)
    self.name = try? container.decode(String.self, forKey: .name)
    self.cod = try? container.decode(Int.self, forKey: .cod)
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
    return lhs.coordinate?.lat == rhs.coordinate?.lat &&
    lhs.coordinate?.lon == rhs.coordinate?.lon
  }
}

// MARK: - Clouds
public struct Clouds: Codable, Hashable {
  let all: Int
}

// MARK: - Coordinate
public struct Coordinate: Codable, Hashable {
  let lon, lat: Double
}

// MARK: - Main
public struct Main: Codable, Hashable {
  let temp, feelsLike, tempMin, tempMax: Double
  let pressure, humidity, seaLevel, grndLevel: Int

  enum CodingKeys: String, CodingKey {
    case temp, pressure, humidity, seaLevel
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case grndLevel = "grnd_level"
    case tempMax = "temp_max"
  }
}

// MARK: - Sys
public struct Sys: Codable, Hashable {
  let type, id: Int
  let country: String
  let sunrise, sunset: Int
}

// MARK: - Weather
public struct Weather: Codable, Hashable {
  let id: Int
  let main, description, icon: String
}

// MARK: - Wind
public struct Wind: Codable, Hashable {
  let speed: Double
  let deg: Int
  let gust: Double
}
