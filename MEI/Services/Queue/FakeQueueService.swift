//
//  FakeQueueService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import Foundation
import ObjectMapper


final class FakeQueueService {
	weak var output: QueueServiceOutput?
}


extension FakeQueueService: QueueServiceInput {
	func getPlaces(for visitType: Int, education: Int, intervals: Int) {
		let queueResponseString = """
{
	"has_intervals": 1,
	"intervals": {
		"258": {
			"IdTimeInterval": "258",
			"Day": "18.06.2018",
			"BeginTime": "10:00",
			"EndTime": "11:00"
		},
		"259": {
			"IdTimeInterval": "259",
			"Day": "18.06.2018",
			"BeginTime": "11:00",
			"EndTime": "12:00"
		},
		"260": {
			"IdTimeInterval": "260",
			"Day": "18.06.2018",
			"BeginTime": "12:00",
			"EndTime": "13:00"
		},
		"261": {
			"IdTimeInterval": "261",
			"Day": "18.06.2018",
			"BeginTime": "13:00",
			"EndTime": "14:00"
		},
		"262": {
			"IdTimeInterval": "262",
			"Day": "18.06.2018",
			"BeginTime": "14:00",
			"EndTime": "15:00"
		},
		"263": {
			"IdTimeInterval": "263",
			"Day": "18.06.2018",
			"BeginTime": "15:00",
			"EndTime": "16:00"
		}
	},
	"room": {
		"258": "10",
		"259": "20",
		"260": "20",
		"261": "15",
		"262": "15",
		"263": "15"
	}
}
"""
		let queueResponse = try! QueueResponse(JSONString: queueResponseString)
		self.output?.didGetPlaces(queueResponse)
	}
	
	func set(output handler: QueueServiceOutput) {
		self.output = handler
	}
}
