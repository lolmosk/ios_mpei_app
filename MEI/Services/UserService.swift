//
//  UserService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 24.06.2018.
//

import Foundation
import ObjectMapper
import Alamofire

protocol UserServiceInput {
	func getInfo(with nic: String, padding: String, sign: String,
							 success: @escaping () -> (),
							 failure: @escaping (_ error: Error) -> ())
}

final class UserService {
	
}

extension UserService: UserServiceInput {
	func getInfo(with nic: String, padding: String, sign: String,
							 success: @escaping () -> (),
							 failure: @escaping (_ error: Error) -> ()) {
		let api = API.User.info(nic: nic, padding: padding, sign: sign)
		Networking.postRequestString(api, success: { (stringResponse) in
				let components = stringResponse.components(separatedBy: "&")
		}) { (error) in
			failure(error)
		}
	}
}
