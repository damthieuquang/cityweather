//
//  Router.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation

public typealias ServiceRouterCompletion = (
  _ data: Data?,
  _ response: URLResponse?,
  _ error: Error?
) -> Void

/// A protocol for a network router.
protocol ServiceRouter: AnyObject {
  associatedtype EndPoint: EndPointType
  func request(_ route: EndPoint, completion: @escaping ServiceRouterCompletion)
  func cancel()
}

class Router<EndPoint: EndPointType>: ServiceRouter {
  private var task: URLSessionTask?

  /// Initiates a network request.
  /// - Parameters:
  ///  - route: The endpoint to request.
  ///  - completion: The completion handler.
  func request(_ route: EndPoint, completion: @escaping ServiceRouterCompletion) {
    let session = URLSession.shared
    do {
      let request = try buildRequest(from: route)
      task = session.dataTask(with: request, completionHandler: { data, response, error in
        completion(data, response, error)
      })
    } catch {
      completion(nil, nil, error)
    }
    task?.resume()
  }

  func cancel() {
    task?.cancel()
  }
}

private extension Router {

  /// Builds a URLRequest from the given endpoint.
  /// - Parameter route: The endpoint to build the request from.
  /// - Returns: The built URLRequest.
  /// - Throws: An error if the request cannot be built.
  func buildRequest(from route: EndPoint) throws -> URLRequest {
    var request = URLRequest(
      url: route.fullURL,
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      timeoutInterval: 10.0
    )

    request.httpMethod = route.httpMethod.rawValue
    do {
      switch route.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case let .requestParameters(
        bodyEncoding,
        urlParameters
      ):
        addAdditionalHeaders(route.headers, request: &request)
        try configureParameters(
          bodyParameters: route.parameters,
          bodyEncoding: bodyEncoding,
          urlParameters: urlParameters,
          request: &request
        )
      }
      return request
    } catch {
      throw error
    }
  }

  /// Configures the parameters for the given request.
  /// - Parameters:
  ///  - bodyParameters: The body parameters.
  ///  - bodyEncoding: The encoding for the body parameters.
  ///  - urlParameters: The URL parameters.
  ///  - request: The request to configure.
  func configureParameters(
    bodyParameters: Parameters?,
    bodyEncoding: ParameterEncoding,
    urlParameters: Parameters?,
    request: inout URLRequest
  ) throws {
    do {
      try bodyEncoding.encode(
        urlRequest: &request,
        bodyParameters: bodyParameters,
        urlParameters: urlParameters
      )
    } catch {
      throw error
    }
  }

  /// Adds additional headers to the request.
  /// - Parameters:
  ///   - additionalHeaders: The additional headers to add.
  ///   - request: The request to add headers to.
  func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
    guard let headers = additionalHeaders else { return }
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
  }
}
