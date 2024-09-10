//
//  RealmService.swift
//  CWModels
//
//  Created by Quang Dam on 10/9/24.
//

import Foundation
import RealmSwift

public class RealmService {
  public static let shared = RealmService()

  private let realm: Realm

  public init(realm: Realm? = nil) {
    do {
      self.realm = try realm ?? Realm()
      print("Realm file path: \(self.realm.configuration.fileURL?.absoluteString ?? "")")
    } catch {
      fatalError("Failed to initialize Realm: \(error)")
    }
  }

  /// Adds a new city to the database
  /// - Parameter city: The city to add
  /// - Throws: RealmError if the operation fails
  public func addCity(city: City) throws {
    try realm.write {
      realm.add(city.toRealmObject())
    }
  }

  /// Retrieves all cities from the database
  /// - Returns: An array of City objects
  /// - Throws: RealmError if the operation fails
  public func getCities() throws -> [City] {
    return realm.objects(CityRealmObject.self).map { $0.toModel() }
  }

  /// Updates an existing city in the database
  /// - Parameter city: The city to update
  /// - Throws: RealmError if the operation fails
  public func updateCity(city: City) throws {
    try realm.write {
      realm.add(city.toRealmObject(), update: .modified)
    }
  }

  /// Deletes a city from the database
  /// - Parameter city: The city to delete
  /// - Throws: RealmError if the operation fails
  public func deleteCity(city: City) throws {
    try realm.write {
      realm.delete(city.toRealmObject())
    }
  }
}
