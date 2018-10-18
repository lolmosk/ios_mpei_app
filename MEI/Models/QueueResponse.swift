//
//  QueueResponse.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import Foundation
import ObjectMapper


struct QueueResponse {
	var hasIntervals: Int
	var intervals: [String: IntervalResponse]
	var room: [String: String]
	
}


extension QueueResponse: ImmutableMappable {
	init(map: Map) throws {
		hasIntervals = try map.value("has_intervals")
		intervals = try map.value("intervals")
		room = try map.value("room")
	}
	
	func mapping(map: Map) {
		
	}
}
