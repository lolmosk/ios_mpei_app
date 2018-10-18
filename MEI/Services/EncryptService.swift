//
//  EncryptService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import SwiftyRSA
import ISO8859


protocol EncryptServiceInput {
	func encrypt(_ message: String) -> String
	func verify(_ encrypted: String, clearMessage: String) -> Bool
	
	var publicKey: PublicKey { get }
	var keychainService: KeychainService { get }
}


final class EncryptService {
	
	let keychainService = KeychainService()
	
	let publicKey: PublicKey
	private let privateKey: PrivateKey
	
	private(set) var sitePublicKey: PublicKey
	
	init() throws {
		sitePublicKey = try PublicKey(pemNamed: "sitepublickey")
//		guard  let pubKey = keychainService.get(for: .publicKey),
//			let privKey = keychainService.get(for: .privateKey) else {
				let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
				publicKey = keyPair.publicKey
				privateKey = keyPair.privateKey
				keychainService.set(try publicKey.base64String(), for: .publicKey)
				keychainService.set(try privateKey.base64String(), for: .privateKey)
//				return
//		}
//		publicKey = try PublicKey(base64Encoded: pubKey)
//		privateKey = try PrivateKey(base64Encoded: privKey)
	}
	
}

extension EncryptService: EncryptServiceInput {
	func encrypt(_ message: String) -> String {
		print(message)
		let clear = try! ClearMessage(string: message, using: .utf8)
		let base64 = try! clear.signed(with: privateKey, digestType: .sha1).base64String
		let data = base64.data(using: .utf8)
		let encoding = ISO8859.part1
		let string = String(bytes: data!, iso8859Encoding: encoding)
		
		let clearS = try! ClearMessage(string: message, using: .utf8)
		let signature = try! Signature(base64Encoded: string!)
		let isSuccessful = try! clearS.verify(with: publicKey,
																				signature: signature,
																				digestType: .sha1)
		return string!
	}
	
	func verify(_ encrypted: String, clearMessage: String) -> Bool {
		do {
			let clear = try ClearMessage(string: clearMessage, using: .utf8)
			let signature = try Signature(base64Encoded: encrypted)
			let isSuccessful = try clear.verify(with: sitePublicKey,
																					signature: signature,
																					digestType: .sha1)
			return isSuccessful
		} catch {
			return false
		}
	}
}

extension String {
	
	// Url percent encoding according to RFC3986 specifications
	// https://tools.ietf.org/html/rfc3986#section-2.1
	func urlPercentEncoded(withAllowedCharacters allowedCharacters:
		CharacterSet, encoding: String.Encoding) -> String {
		var returnStr = ""
		
		// Compute each char seperatly
		for char in self {
			let charStr = String(char)
			let charScalar = charStr.unicodeScalars[charStr.unicodeScalars.startIndex]
			if allowedCharacters.contains(charScalar) == false,
				let bytesOfChar = charStr.data(using: encoding) {
				// Get the hexStr of every notAllowed-char-byte and put a % infront of it, append the result to the returnString
				for byte in bytesOfChar {
					returnStr += "%" + String(format: "%02hhX", byte as CVarArg)
				}
			} else {
				returnStr += charStr
			}
		}
		
		return returnStr
	}
	
}
