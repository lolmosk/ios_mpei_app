//
//  API.swift
//  Reminiway
//
//  Created by Alex Lavrinenko on 10.09.16.
//  Copyright © 2016 Alex Lavrinenko. All rights reserved.
//

import UIKit
import Alamofire


enum API {
  static let mobileUrl = "https://www.pkmpei.ru/mobile/"
	static let mainUrl = "https://www.pkmpei.ru/ajax/"
}


protocol APIMethodProtocol: URLRequestConvertible {
  var method: Alamofire.HTTPMethod { get }
  var path: String { get }
  var params: [String : Any]? { get }
	var multipartData: (MultipartFormData) -> Void { get }
}


extension APIMethodProtocol {
  
  func asURLRequest() throws -> URLRequest {
    var request = URLRequest(url: URL(string: path)!)
    request.httpMethod = method.rawValue
		
    switch method {
    case .get:
      return try Alamofire.URLEncoding.default.encode(request, with: params)
    case .post:
      return try Alamofire.JSONEncoding.default.encode(request, with: params)
    case .put:
      return try Alamofire.JSONEncoding.default.encode(request, with: params)
    default:
      return try Alamofire.URLEncoding.default.encode(request, with: params)
    }
  }
	
	var multipartData: (MultipartFormData) -> Void {
		let multipartFormData: (MultipartFormData) -> (Void) = { (data) in
			for (key, value) in self.params! {
				data.append("\(value)".data(using: .utf8)!, withName: key)
			}
		}
		return multipartFormData
	}
}
