//
//  KeychainService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 18.06.2018.
//

import KeychainSwift

final class KeychainService {
	enum Keys: String {
		case nick
		case userId
		case publicKey
		case privateKey
		case firebaseToken
	}
	
	let keychain = KeychainSwift()
	
	func set(_ value: String, for key: Keys) {
		keychain.set(value, forKey: key.rawValue)
	}
	
	func get(for key: Keys) -> String? {
		return keychain.get(key.rawValue)
	}
}
