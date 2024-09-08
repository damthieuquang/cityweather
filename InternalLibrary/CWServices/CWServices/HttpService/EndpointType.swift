//
//  EndpointType.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation

public enum EndpointVersion: String {
  case none = ""
  case ver1, ver2
}

/// The type of HTTP method to use in the request.
protocol EndPointType {
  var baseURL: String { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: HTTPHeaders? { get }
  var version: EndpointVersion { get }
  var parameters: [String: Any]? { get }
}

extension EndPointType {
  /// The full URL of the endpoint.
  var fullURL: URL {
    guard var fullUrl = URL(string: baseURL) else {
      fatalError("Invalid baseUrl")
    }

    fullUrl = fullUrl.appendingPathComponent(version.rawValue)
    fullUrl = fullUrl.appendingPathComponent(path)

    return fullUrl.absoluteString.removingPercentEncoding.flatMap(URL.init(string:)) ?? fullUrl
  }

}
