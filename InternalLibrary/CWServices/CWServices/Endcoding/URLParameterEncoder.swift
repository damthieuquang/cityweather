//
//  URLParameterEncoder.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
  /// Encodes the given parameters into the URL of the URLRequest.
  ///
  /// - Parameters:
  ///   - urlRequest: The URLRequest to encode the parameters into.
  ///   - parameters: The parameters to encode.
  /// - Throws: An error of type `NetworkError` if the URL is missing.
  public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    guard let url = urlRequest.url else { throw NetworkError.missingURL }

    if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
      urlComponents.queryItems = [URLQueryItem]()

      for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key,
                                     value: "\(value)"
          .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        urlComponents.queryItems?.append(queryItem)
      }

      urlRequest.url = urlComponents.url
    }

    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
  }
}
