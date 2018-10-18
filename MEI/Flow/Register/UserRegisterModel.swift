//
//  UserRegisterModel.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import ObjectMapper

final class UserReisterModel {
	var name: String?
	var lastname: String?
	var middlename: String?
	var email: String?
	var question: String?
	var answer: String?
	var birthDate: String?
	
	var isComplete: Bool {
		guard let _ = name,
			let _ = lastname,
			let _ = middlename,
			let _ = email,
			let _ = question,
			let _ = answer,
			let _ = birthDate else {
				return false
		}
		return true
	}
}
