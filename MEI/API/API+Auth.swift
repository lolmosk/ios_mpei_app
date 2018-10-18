//
//  AuthService.swift
//  LifeWays
//
//  Created by Alex Lavrinenko on 29.03.16.
//  Copyright © 2016 Alex Lavrinenko. All rights reserved.
//

import Alamofire
import Foundation


extension API {
	enum Auth {
		static let url = API.mobileUrl
		case auth(
			login: String,
			publicKey: String,
			password: String,
			token: String)
		case authQuick(
			method: Int,
			login: String,
			sign: String,
			token: String)
		
		case register(
			method: Int,
			name: String,
			lastname: String,
			middlename: String,
			email: String,
			question: String,
			answer: String,
			birthDate: String,
			token: String,
			publicKey: String
		)
	}
}

extension API.Auth: APIMethodProtocol {
	
	var method: Alamofire.HTTPMethod {
		return .post
	}
	
	var path: String {
		switch self {
		case .auth, .authQuick:
			return API.Auth.url + "auth.php"
		case .register:
			return API.Auth.url + "reg.php"
		}
	}
	
	var params: [String: Any]? {
		switch self {
		case .auth(
			let login,
			let publicKey,
			let password,
			let token):
			return ["method": 2,
							"nic": login,
							"mobilePubKey": publicKey,
							"password": password,
							"token": token,]
		case .authQuick(
			let method,
			let login,
			let sign,
			let token):
			return ["method": method,
							"nic": login,
							"sign": sign,
							"token": token,
			]
		case .register(
			let method,
			let name,
			let lastname,
			let middlename,
			let email,
			let question,
			let answer,
			let birthDate,
			let token,
			let publicKey
			):
			return ["method": method,
							"name": name,
							"surname": lastname,
							"patronymic": middlename,
							"token": token,
							"email": email,
							"question": question,
							"answer": answer,
							"mobilePubKey": publicKey,
							"birthDate": birthDate,
							"capcha": "fakeCaptcha"
			]
		}
	}
	
	var multipartData: (MultipartFormData) -> Void {
		let multipartFormData: (MultipartFormData) -> (Void) = { (data) in
			let jsonString = self.params!.json
			print(jsonString)
			data.append(jsonString.data(using: .utf8)!, withName: "param")
		}
		return multipartFormData
	}
}
