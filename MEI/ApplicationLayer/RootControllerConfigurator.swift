//
//  RootControllerConfigurator.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import UIKit

class RootControllerConfigurator: ConfiguratorProtocol {
	
	func configure(_ application: UIApplication) {
		guard let nick = AppDelegate.encryptService.keychainService.get(for: .nick),
		let token = AppDelegate.encryptService.keychainService.get(for: .firebaseToken) else {
			return AppDelegate.currentWindow.rootViewController = R.storyboard.auth.authNavigationViewController()
		}
		let loadingVc = R.storyboard.auth.loadingViewController()
		loadingVc?.nick = nick
		loadingVc?.token = token
		AppDelegate.currentWindow.rootViewController = loadingVc
	}
}
