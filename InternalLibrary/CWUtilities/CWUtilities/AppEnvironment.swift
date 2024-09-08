//
//  AppEnvironment.swift
//  CWUtilities
//
//  Created by Quang Dam on 9/9/24.
//

import Foundation

public enum AppEnvironment {
  case debug
}

public extension AppEnvironment {
  static let aaa = "bbb"

  static let configuration: EnvironmentConfig = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let url = Bundle.main.url(forResource: "config", withExtension: "json")!
    do {
      let data = try Data(contentsOf: url)
      return try decoder.decode(EnvironmentConfig.self, from: data)
    } catch {
      fatalError("Something went wrong, please check configurations again!")
    }
  }()
}
