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

  public func toModel() -> City {
    let weatherArray = weather.map { weatherRealmObject in
      return Weather(
        id: weatherRealmObject.id,
        main: weatherRealmObject.main,
        description: weatherRealmObject.desc,
        icon: weatherRealmObject.icon
      )
    }

    let weatherModel: [Weather]? = weatherArray.isEmpty ? nil : Array(weatherArray)

    let mainModel: Main?
    if let mainRealm = main {
      mainModel = Main(
        temp: mainRealm.temp,
        feelsLike: mainRealm.feelsLike,
        tempMin: mainRealm.tempMin,
        tempMax: mainRealm.tempMax,
        pressure: mainRealm.pressure,
        humidity: mainRealm.humidity,
        seaLevel: mainRealm.seaLevel,
        grndLevel: mainRealm.grndLevel
      )
    } else {
      mainModel = nil
    }

    let windModel: Wind?
    if let windRealm = wind {
      windModel = Wind(
        speed: windRealm.speed,
        deg: windRealm.deg,
        gust: windRealm.gust
      )
    } else {
      windModel = nil
    }

    let cloudsModel: Clouds?
    if let cloudsRealm = clouds {
      cloudsModel = Clouds(all: cloudsRealm.all)
    } else {
      cloudsModel = nil
    }

    let city = City(
      coordinate: nil,
      weather: weatherModel,
      base: nil,
      main: mainModel,
      visibility: nil,
      wind: windModel,
      clouds: cloudsModel,
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
