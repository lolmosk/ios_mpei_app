//
//  AuthService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper


protocol AuthServiceInput {
	func logIn(with user: UserAuthModel, publicKey: String, firebaseToken: String)
	func quickLogIn(with nick: String, firebaseToken: String)
	func logInForWeb(with nick: String, firebaseToken: String)
	func set(output handler: AuthServiceOutput)
}


protocol AuthServiceOutput: class {
	func didRecieveError(_ error: Error)
	func didLogIn(_ authResponse: AuthResult)
	func didQuickLogIn(_ authResponse: QuickAuthResult)
}


final class AuthService {
	weak var output: AuthServiceOutput?
}


extension AuthService: AuthServiceInput {
	func logInForWeb(with nick: String, firebaseToken: String) {
		let method = 3
		auth(with: method, nick: nick, firebaseToken: firebaseToken)
	}
	
	private func auth(with method: Int, nick: String, firebaseToken: String) {
		let clearMessage = "\(method)\(nick)\(firebaseToken)"
		let sign = AppDelegate.encryptService.encrypt(clearMessage)
		let authAPI = API.Auth.authQuick(method: method,
																		 login: nick,
																		 sign: sign,
																		 token: firebaseToken)
		Networking.postRequest(authAPI, success: { [weak self] (authResult: QuickAuthResult) in
			self?.output?.didQuickLogIn(authResult)
		}) { [weak self] (error) in
			self?.output?.didRecieveError(NetworkError.mappingError)
			return
		}
	}
	
	func quickLogIn(with nick: String, firebaseToken: String) {
		let method = 1
		auth(with: method, nick: nick, firebaseToken: firebaseToken)
	}
	
	typealias AuthResponse = DataResponse<AuthResult>
	func logIn(with user: UserAuthModel, publicKey: String, firebaseToken: String) {
		let authAPI = API.Auth.auth(login: user.login!,
																publicKey: publicKey,
																password: user.password!,
																token: firebaseToken)
		let jsonString = authAPI.params!.json
		Alamofire.upload(multipartFormData: { (data) in
			data.append(jsonString.data(using: .utf8)!, withName: "param")
		}, usingThreshold: UInt64(),
			 to: authAPI.path, method: authAPI.method, headers: nil,
			 encodingCompletion: { [weak self] (encodingResult) in
				switch encodingResult {
				case .success(let upload, _, _):
					let req = upload.responseObject(completionHandler: { (response: AuthResponse) in
						guard let authResult = response.value else {
							self?.output?.didRecieveError(NetworkError.mappingError)
							return
						}
						
						self?.output?.didLogIn(authResult)
					})
					
					debugPrint(req)
				case .failure:
					self?.output?.didRecieveError(NetworkError.mappingError)
					return
				}
		})
	}
	
	func set(output handler: AuthServiceOutput) {
		self.output = handler
	}
}

protocol Verifiable {
	var clearMessage: String { get }
}

struct AuthResult {
	let publicKey: String
	let userId: Int
	let login: String
	let status: String
	let sign: String
}

extension AuthResult: ImmutableMappable {
	init(map: Map) throws {
		publicKey = try map.value("userPublicKey")
		userId = try map.value("userId")
		login = try map.value("userNic")
		status = try map.value("status")
		sign = try map.value("sign")
	}
	
	func mapping(map: Map) {
		
	}
}

extension AuthResult: Verifiable {
	var clearMessage: String {
		let decodedString = publicKey.fromBase64()!
		return "\(decodedString)\(userId)\(login)\(status)"
	}
}

struct QuickAuthResult {
	let ticket: String?
	let status: String
	let pudding͟: String
	let sign: String
}

extension QuickAuthResult: ImmutableMappable {
	init(map: Map) throws {
		ticket = try? map.value("tiket")
		status = try map.value("status")
		pudding͟ = try map.value("pudding͟")
		sign = try map.value("sign")
	}
	
	func mapping(map: Map) {
		
	}
}

extension QuickAuthResult: Verifiable {
	var clearMessage: String {
		let clearMessage = "\(status)\(pudding͟)"
		guard let ticket = ticket else {
			return clearMessage
		}
		return "\(clearMessage)\(ticket)"
	}
}

extension Dictionary {
	var json: String {
		let invalidJson = "Not a valid JSON"
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
			return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
		} catch {
			return invalidJson
		}
	}
	
	func dict2json() -> String {
		return json
	}
}

extension String {
	
	func fromBase64() -> String? {
		guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
			return nil
		}
		
		return String(data: data as Data, encoding: String.Encoding.utf8)
	}
	
	func toBase64() -> String? {
		guard let data = self.data(using: String.Encoding.utf8) else {
			return nil
		}
		
		return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
	}
}

