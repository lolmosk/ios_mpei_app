//
//  API+User.swift
//  MEI
//
//  Created by Alex Lavrinenko on 24.06.2018.
//

import Foundation
import Alamofire


extension API {
	enum User {
		static let url = API.mobileUrl
		case info(nic: String, padding: String, sign: String)
	}
}

extension API.User: APIMethodProtocol {
	
	var method: Alamofire.HTTPMethod {
		return .post
	}
	
	var path: String {
		switch self {
		case .info:
			return API.User.url + "get_person_info.php"
		}
	}
	
	var params: [String: Any]? {
		switch self {
		case .info(
			let nic,
			let padding,
			let sign):
			return ["nic": nic,
							"padding": padding,
							"sign": sign,]
		}
	}
	
	var multipartData: (MultipartFormData) -> Void {
		let multipartFormData: (MultipartFormData) -> (Void) = { (data) in
			guard let params = self.params else {
				return
			}
			for (key, value) in params {
				data.append("\(value)".data(using: .utf8)!, withName: key)
			}
		}
		return multipartFormData
	}
}
