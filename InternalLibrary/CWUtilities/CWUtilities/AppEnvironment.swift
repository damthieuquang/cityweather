//
//  AppEnvironment.swift
//  CWUtilities
//
//  Created by Quang Dam on 9/9/24.
//

import Foundation

public enum AppEnvironment: String {
  case staging, production
}

public extension AppEnvironment {
  private static let appEnvironmentKey = "app_environment"

  static let current: AppEnvironment = {
    let value = Bundle.main.object(forInfoDictionaryKey: appEnvironmentKey) as? String ?? "staging"
    return AppEnvironment(rawValue: value)!
  }()

  var apiKey: String {
    switch self {
    case .staging: "43fa32f315e5f7de39417b6f3fee3f03"
    case .production: ""
    }
  }

  var baseURL: String {
    switch self {
    case .staging: "https://api.openweathermap.org/data"
    case .production: ""
    }
  }
}
