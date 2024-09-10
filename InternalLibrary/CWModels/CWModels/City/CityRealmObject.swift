//
//  CityRealmObject.swift
//  CWModels
//
//  Created by Quang Dam on 10/9/24.
//

import Foundation
import RealmSwift

public class CityRealmObject: Object {
  @Persisted(primaryKey: true) var id: Int
  @Persisted var name: String
  @Persisted var country: String
  @Persisted var weather: List<WeatherRealmObject>
  @Persisted var main: MainRealmObject?
  @Persisted var wind: WindRealmObject?
  @Persisted var clouds: CloudsRealmObject?
  @Persisted var isFavourite: Bool

  func toModel() -> City {
    let weatherArray = weather.map { weatherRealmObject in
      return Weather(
        id: weatherRealmObject.id,
        main: weatherRealmObject.main,
        description: weatherRealmObject.desc,
        icon: weatherRealmObject.icon
      )
    }

    let main = Main(
      temp: main?.temp ?? 0,
      feelsLike: main?.feelsLike ?? 0,
      tempMin: main?.tempMin ?? 0,
      tempMax: main?.tempMax ?? 0,
      pressure: main?.pressure ?? 0,
      humidity: main?.humidity ?? 0,
      seaLevel: main?.seaLevel ?? 0,
      grndLevel: main?.grndLevel ?? 0
    )

    let wind = Wind(
      speed: wind?.speed ?? 0,
      deg: wind?.deg ?? 0,
      gust: wind?.gust ?? 0
    )

    let clouds = Clouds(all: clouds?.all ?? 0)

    let city = City(
      coordinate: nil,
      weather: Array(weatherArray),
      base: nil,
      main: main,
      visibility: nil,
      wind: wind,
      clouds: clouds,
      timeData: nil,
      sys: Sys(
        type: 0,
        id: id,
        country: country,
        sunrise: 0,
        sunset: 0
      ),
      timezone: nil,
      id: id,
      name: name,
      cod: nil,
      isFavourite: isFavourite
    )

    return city
  }

}

class WeatherRealmObject: Object {
  @Persisted(primaryKey: true) var id: Int
  @Persisted var main: String
  @Persisted var desc: String
  @Persisted var icon: String
}

class MainRealmObject: Object {
  @Persisted(primaryKey: true) var id: String = UUID().uuidString
  @Persisted var temp: Double
  @Persisted var feelsLike: Double
  @Persisted var tempMin: Double
  @Persisted var tempMax: Double
  @Persisted var pressure: Int
  @Persisted var humidity: Int
  @Persisted var seaLevel: Int
  @Persisted var grndLevel: Int
}

class WindRealmObject: Object {
  @Persisted(primaryKey: true) var id: String = UUID().uuidString
  @Persisted var speed: Double
  @Persisted var deg: Int
  @Persisted var gust: Double
}

class CloudsRealmObject: Object {
  @Persisted(primaryKey: true) var id: String = UUID().uuidString
  @Persisted var all: Int
}
