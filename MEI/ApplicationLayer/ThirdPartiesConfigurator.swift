//
// Created by Dmitry Ivanenko on 13.03.17.
// Copyright (c) 2017 Doggy. All rights reserved.
//

import Foundation
import AlamofireNetworkActivityIndicator
import IQKeyboardManagerSwift
import Firebase
import UserNotifications


class ThirdPartiesConfigurator: ConfiguratorProtocol {
	
	func configure(_ application: UIApplication) {
		IQKeyboardManager.shared.enable = true
		
		// NetworkActivityIndicatorManager
		NetworkActivityIndicatorManager.shared.isEnabled = true
		
		// FirebaseApp
		firebaseConfigure(application)
	}
	
	func firebaseConfigure(_ application: UIApplication) {
		FirebaseApp.configure()

		UNUserNotificationCenter.current().delegate = AppDelegate.firebaseService
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(
			options: authOptions,
			completionHandler: {_, _ in })
		
		application.registerForRemoteNotifications()
	}
}
