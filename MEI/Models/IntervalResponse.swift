//
//  IntervalResponse.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import Foundation
import ObjectMapper


struct IntervalResponse {
	var IdTimeInterval: String
	var day: String
	var begin: String
	var end: String
}

extension IntervalResponse: ImmutableMappable {
	init(map: Map) throws {
		IdTimeInterval = try map.value("IdTimeInterval")
		day = try map.value("Day")
		begin = try map.value("BeginTime")
		end = try map.value("EndTime")
	}
	
	func mapping(map: Map) {
		
	}
}
