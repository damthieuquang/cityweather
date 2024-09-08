//
//  JSONParameterEncoder.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation

/**
 Encodes the given parameters into JSON format and adds it to the HTTP body of the specified URLRequest.
 
 - Parameters:
  - urlRequest: The URLRequest to encode the parameters into.
  - parameters: The parameters to be encoded.
 
 - Throws: `NetworkError.encodingFailed` if the encoding process fails.
 */
public struct JSONParameterEncoder: ParameterEncoder {
  public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    do {
      let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      urlRequest.httpBody = jsonAsData

      if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
    } catch {
      throw NetworkError.encodingFailed
    }
  }
}
