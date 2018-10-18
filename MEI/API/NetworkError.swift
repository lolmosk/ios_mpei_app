//
//  NetworkError.swift
//  EFS
//
//  Created by Dmitry Ivanenko on 19.08.16.
//  Copyright © 2016 Sberbank. All rights reserved.
//

import Foundation
import Alamofire


enum NetworkError: Error {
  
  case notFound
  case parsingError
  case mappingError
  case networkConnectionError
  case noResponse
  case forbidden(reloadData: (() -> Void)?)
  
  case customError(title: String, message: String?)
  
  
  var title: String {
    switch self {
    case .customError(title: let title, message: _):
      return title
    default:
      return "Erorr"
    }
  }
  
  var message: String? {
    switch self {
    case .notFound, .networkConnectionError:
      return "Erorr"
    case .mappingError:
      return "Erorr"
    case .customError(title: _, message: let message):
      return message
    case .noResponse:
      return "Erorr"
    case .forbidden:
      return "Erorr"
    default:
      return nil
    }
  }
  
}
