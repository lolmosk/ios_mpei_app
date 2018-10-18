//
//  QueueLoadResponse.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import Foundation
import ObjectMapper

struct QueueLoadResponse: MainRowViewModel {
	let load: Int
	let datetime: String
	let descrip: String
	let color: String
}

struct QueueNumberResponse: MainRowViewModel {
	
	let from: String
	let value: String
	
	init(from: String, value: String) {
		self.from = from
		self.value = value
	}
}


//extension QueueLoadResponse: ImmutableMappable {
//	
//	init(map: Map) throws {
//		load = try map.value("load")
//		datetime = try map.value("datetime")
//		descrip = try map.value("text")
//		color = try map.value("color")
//	}
//	
//	func mapping(map: Map) {
//		
//	}
//}
