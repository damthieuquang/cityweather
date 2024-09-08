//
//  ParameterEncoding.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
  static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {

  case urlEncoding
  case jsonEncoding
  case urlAndJsonEncoding

  /// Encodes the given body and URL parameters into the provided URLRequest based on the selected encoding type.
  ///
  /// - Parameters:
  ///   - urlRequest: The URLRequest to encode the parameters into.
  ///   - bodyParameters: The body parameters to encode.
  ///   - urlParameters: The URL parameters to encode.
  /// - Throws: An error if the encoding fails.
  public func encode(
    urlRequest: inout URLRequest,
    bodyParameters: Parameters?,
    urlParameters: Parameters?
  ) throws {
    do {
      switch self {
      case .urlEncoding:
        guard let urlParameters = urlParameters else { return }
        try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters)

      case .jsonEncoding:
        guard let bodyParameters = bodyParameters else { return }
        try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)

      case .urlAndJsonEncoding:
        guard let bodyParameters = bodyParameters,
              let urlParameters = urlParameters else { return }
        try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
        try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
      }
    } catch {
      throw error
    }
  }
}

public enum NetworkError: String, Error {
  case parametersNil = "Parameters were nil."
  case encodingFailed = "Parameter encoding failed."
  case missingURL = "URL is nil."
}
