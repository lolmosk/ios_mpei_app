//
//  UserAuthModel.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import Foundation

struct UserAuthModel {
	var login: String?
	var password: String?
	
	var isFilled: Bool {
		guard login != nil, password != nil else {
			return false
		}
		return true
	}
	
}
