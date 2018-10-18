//
//  SendDocumentsViewController.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import UIKit

class SendDocumentsViewController: UIViewController {
	
	@IBOutlet weak var sendButton: UIButton!
	
	let authService: AuthServiceInput = AuthService()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		authService.set(output: self)
		guard let nick = AppDelegate.encryptService.keychainService.get(for: .nick),
			let token = AppDelegate.encryptService.keychainService.get(for: .firebaseToken) else {
				self.didRecieveError(NetworkError.notFound)
				return
		}
		authService.logInForWeb(with: nick, firebaseToken: token)
	}
	
	@IBAction func didPressedSendDocumentsButton(_ sender: UIButton) {
		
	}
}

extension SendDocumentsViewController: AuthServiceOutput {
	
	func didLogIn(_ authResponse: AuthResult) {
		
	}
	
	func didQuickLogIn(_ authResponse: QuickAuthResult) {
		
	}
	
	func didRecieveError(_ error: Error) {
		
	}
}

