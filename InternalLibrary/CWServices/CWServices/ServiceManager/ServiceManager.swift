//
//  ServiceManager.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation
import CWModels

enum ServiceResponse: String {
  case success
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

enum Result<String> {
  case success
  case failure(String)
}

public class ServiceManager {
//  static let environment: NetworkEnvironment = .staging
  public static let shared = ServiceManager()

  public init() {}
}

public extension ServiceManager {
  func getCityByName(cityName: String,
                     completion: @escaping (_ city: City?, _ error: String?) -> Void) {
    let router = Router<CityService>()
    router.request(.city(name: cityName)) { data, response, error in
      if error != nil {
        completion(nil, "Please check your network connection.")
      }

      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, ServiceResponse.noData.rawValue)
            return
          }
          do {
            let city = try JSONDecoder().decode(City.self, from: responseData)
            completion(city, nil)
          } catch {
            completion(nil, ServiceResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
}

private extension ServiceManager {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
    case 200 ... 299: return .success
    case 401 ... 500: return .failure(ServiceResponse.authenticationError.rawValue)
    case 501 ... 599: return .failure(ServiceResponse.badRequest.rawValue)
    case 600: return .failure(ServiceResponse.outdated.rawValue)
    default: return .failure(ServiceResponse.failed.rawValue)
    }
  }
}
