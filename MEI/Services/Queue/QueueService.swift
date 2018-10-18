//
//  QueueService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 17.06.2018.
//

import Foundation
import ObjectMapper
import Alamofire


final class QueueService {
	weak var output: QueueServiceOutput?
}


extension QueueService: QueueServiceInput {
	func getPlaces(for visitType: Int, education: Int, intervals: Int) {
		let api = API.Queue.places(visitType: visitType,
															 education: education,
															 intervals: intervals)
		Networking.postRequest(api, success: { (queueResponse: QueueResponse) in
			self.output?.didGetPlaces(queueResponse)
		}) { (error: Error) in
			self.output?.didRecieveError(error)
		}
	}
	
	func getQueueLoad(result: @escaping (_ response: QueueLoadResponse) -> (),
										error: @escaping (_ error: Error) -> ()) {
		let api = API.Queue.load()
		request(api).responseString { (response) in
			if let responseString = response.value {
				let sepString = responseString.components(separatedBy: "&")
				let queueResponse = QueueLoadResponse(load: Int(sepString[0])!,
																							datetime: sepString[1],
																							descrip: sepString[2],
																							color: sepString[3])
				result(queueResponse)
			} else {
				error(response.error!)
			}
		}
	}
	
	func getQueueNumbers(result: @escaping (_ response: [QueueNumberResponse]) -> (),
											 error: @escaping (_ error: Error) -> ()) {
		
		let api = API.Queue.numbers()
		request(api).responseString { (response) in
			if let responseString = response.value {
				let responseFiltered = responseString.replacingOccurrences(of: "STATUS=OK&", with: "")
				let components = responseFiltered.components(separatedBy: "&")
				var numbers = [QueueNumberResponse]()
				var dictionary = [String: String]()
				for component in components {
					let keyValue = component.components(separatedBy: "=")
					if var key = keyValue.first, let value = keyValue.last,
						key.contains("[") {
						key = key.replacingOccurrences(of: "from[", with: "")
						key = key.replacingOccurrences(of: "to[", with: "")
						key = key.replacingOccurrences(of: "]", with: "")
						if dictionary[key] != nil {
							dictionary[key] = "\(dictionary[key]!)-\(value)"
						}
						else {
							dictionary[key] = value
						}
					}
				}
				
				for (key, value) in dictionary {
					numbers.append(QueueNumberResponse(from: key, value: value))
				}
				numbers.sort(by: {$0.from < $1.from })
				result(numbers)
			} else {
				error(response.error!)
			}
		}
	}
	
	func  set(output handler: QueueServiceOutput) {
		self.output = handler
	}
}
