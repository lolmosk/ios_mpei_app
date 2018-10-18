//
//  API++Queue.swift
//  MEI
//
//  Created by Alex Lavrinenko on 17.06.2018.
//

import Alamofire
import Foundation


extension API {
	enum Queue {
		static let url = API.mainUrl + "queue/"
		case places(visitType: Int, education: Int, intervals: Int)
		case load()
		case numbers()
	}
}

extension API.Queue: APIMethodProtocol {
	
	var method: Alamofire.HTTPMethod {
		return .post
	}
	
	var path: String {
		switch self {
		case .places:
			return API.Queue.url + "pk_get_reserve_room.php"
		case .load():
			return API.mobileUrl + "get_queue_load.php"
		case .numbers():
			return API.mobileUrl + "get_queue_numbers.php"
		}
	}
	
	var params: [String: Any]? {
		switch self {
		case .places(
			let visitType,
			let education,
			let intervals):
			return ["VisitType": visitType,
							"EducationLevel": education,
							"Intervals": intervals,]
		case .load(), .numbers():
			return nil
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
