//
//  CityService.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation
import CWUtilities

enum CityService {
  case city(name: String)
}

extension CityService: EndPointType {
  var baseURL: String { AppEnvironment.current.baseURL }
  var path: String { "weather" }
  var httpMethod: HTTPMethod { .get }
  var version: EndpointVersion { .ver2x }

  var task: HTTPTask {
    switch self {
    case let .city(name):
      return .requestParameters(bodyEncoding: .urlEncoding, urlParameters: [
        "q": name,
        "appid": AppEnvironment.current.apiKey,
        "units": "metric"
      ])
    }
  }

  var headers: HTTPHeaders? { nil }
  var parameters: [String: Any]? { nil }
}
