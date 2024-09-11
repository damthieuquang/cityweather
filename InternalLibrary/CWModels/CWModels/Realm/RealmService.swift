//
//  RealmService.swift
//  CWModels
//
//  Created by Quang Dam on 10/9/24.
//

import Foundation
import RealmSwift

public class RealmService {
  private let realm: Realm

  /// Initialize RealmService with optional Realm instance
  public init(realm: Realm? = nil) {
    do {
      self.realm = try realm ?? Realm()
      print("Realm file path: \(self.realm.configuration.fileURL?.absoluteString ?? "")")
    } catch {
      preconditionFailure("Cannot create realm")
    }
  }

  /// Add a city to the database
  public func addCity(city: City) {
    do {
      try realm.write {
        realm.add(city.toObject())
      }
    } catch {
      print("Error adding city: \(error.localizedDescription)")
    }
  }

  /// Get all cities from the database
  public func getCities() -> [City] {
      let cityRealmObjects = realm.objects(CityRealmObject.self)
      return cityRealmObjects.map { $0.toModel() }
  }

  /// Update a city in the database
  public func updateCity(city: City) {
    do {
      try realm.write {
        realm.add(city.toObject(), update: .modified)
      }
    } catch {
      print("Error updating city: \(error.localizedDescription)")
    }
  }

  /// Delete a city from the database
  public func deleteCity(city: City) {
    do {
      let cityObject = realm.object(ofType: CityRealmObject.self, forPrimaryKey: city.id)
      if let cityObject = cityObject {
        try realm.write {
          realm.delete(cityObject)
        }
      } else {
        print("City not found in Realm")
      }
    } catch {
      print("Error deleting city: \(error.localizedDescription)")
    }
  }

  // MARK: - Background Operations

  /// Add a city to the database on a background thread
  public func addCityInBackground(city: City) {
    DispatchQueue.global().async {
      autoreleasepool {
        do {
          let realm = try Realm()  // Create new Realm instance in background thread
          try realm.write {
            realm.add(city.toObject())
          }
        } catch {
          print("Error adding city in background: \(error.localizedDescription)")
        }
      }
    }
  }
}
