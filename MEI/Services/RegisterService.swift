//
//  RegisterService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 16.06.2018.
//

import Foundation
import Alamofire

protocol RegisterServiceInput {
	func register(with user: UserReisterModel, publicKey: String, firebaseToken: String)
	func set(output handler: RegisterServiceOutput)
}


protocol RegisterServiceOutput: class {
	func didRegister(_ sign: String)
	func didRecieveError(_ error: Error)
}

final class RegisterService {
	weak var output: RegisterServiceOutput?
}

extension RegisterService: RegisterServiceInput {
	func register(with user: UserReisterModel, publicKey: String, firebaseToken: String) {
		typealias AuthResponse = DataResponse<AuthResult>
		guard let name = user.name,
			let lastname = user.lastname,
			let middlename = user.middlename,
			let email = user.email,
			let question = user.question,
			let answer = user.answer,
			let birthDate = user.birthDate else {
				return
		}
		let apiRegister = API.Auth.register(
			method: 1,
			name: name,
			lastname: lastname,
			middlename: middlename,
			email: email,
			question: question,
			answer: answer,
			birthDate: birthDate,
			token: firebaseToken,
			publicKey: publicKey)
		let jsonString = apiRegister.params!.json
		Networking.postRequest(apiRegister, success: { [weak self] (response: AuthResult) in
//			guard let authResult = response.value else {
				self?.output?.didRecieveError(NetworkError.mappingError)
//				return
//			}
		}) { [weak self] (err) in
			self?.output?.didRecieveError(NetworkError.mappingError)
		}
//		Alamofire.upload(multipartFormData: { (data) in
//			data.append(jsonString.data(using: .utf8)!, withName: "param")
//		}, usingThreshold: UInt64(),
//			 to: apiRegister.path, method: apiRegister.method, headers: nil,
//			 encodingCompletion: { [weak self] (encodingResult) in
//				switch encodingResult {
//				case .success(let upload, _, _):
//					let req = upload.responseObject(completionHandler: { (response: AuthResponse) in
//						guard let authResult = response.value else {
//							self?.output?.didRecieveError(NetworkError.mappingError)
//							return
//						}
//						self?.output?.didRegister(authResult.sign)
//					})
//
//					debugPrint(req)
//				case .failure:
//					self?.output?.didRecieveError(NetworkError.mappingError)
//					return
//				}
//		})
	}
	
	func set(output handler: RegisterServiceOutput) {
		self.output = handler
	}
}

