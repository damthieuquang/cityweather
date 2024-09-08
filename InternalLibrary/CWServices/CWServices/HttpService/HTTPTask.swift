//
//  HTTPTask.swift
//  CWServices
//
//  Created by Quang Dam on 8/9/24.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
  case request
  case requestParameters(
    bodyEncoding: ParameterEncoding,
    urlParameters: Parameters?
  )
}
