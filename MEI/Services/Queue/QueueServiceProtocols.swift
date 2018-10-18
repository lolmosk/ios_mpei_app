//
//  QueueServiceProtocols.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import Foundation


protocol QueueServiceInput {
	func getPlaces(for visitType: Int, education: Int, intervals: Int)
	func set(output handler: QueueServiceOutput)
}


protocol QueueServiceOutput: class {
	func didGetPlaces(_ queueResponse: QueueResponse)
	func didRecieveError(_ error: Error)
}
