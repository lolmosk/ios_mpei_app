//
//  LoadingViewController.swift
//  MEI
//
//  Created by Alex Lavrinenko on 18.06.2018.
//

import UIKit

class LoadingViewController: UIViewController {
	
	let authService: AuthServiceInput = AuthService()
	var nick: String?
	var token: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		authService.set(output: self)
		guard let nick = nick,
			let token = token else {
				self.didRecieveError(NetworkError.notFound)
				return
		}
		authService.quickLogIn(with: nick,firebaseToken: token)
	}
}

extension LoadingViewController: AuthServiceOutput {
	func didRecieveError(_ error: Error) {
		AppDelegate.currentWindow.rootViewController = R.storyboard.auth.authNavigationViewController()
	}
	
	func didLogIn(_ authResponse: AuthResult) {
		
	}
	
	func didQuickLogIn(_ authResponse: QuickAuthResult) {
		AppDelegate.currentWindow.rootViewController = R.storyboard.main.mainTabBarController()
	}
}
