//
//  AppDelegate.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	static let firebaseService: FirebaseServiceInput = FirebaseService()
	
	// Опасно
	static let encryptService: EncryptServiceInput = try! EncryptService()
	
	private lazy var configurators: [ConfiguratorProtocol] = [
		ThirdPartiesConfigurator(),
		RootControllerConfigurator()
		]
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		for configurator in configurators {
			configurator.configure(application)
		}
		window?.makeKeyAndVisible()
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
		print(deviceTokenString)
		
	}
}

extension AppDelegate {
	
	static func getUserInfo() {
		guard let nick = AppDelegate.encryptService.keychainService.get(for: .nick),
			let token = AppDelegate.encryptService.keychainService.get(for: .firebaseToken),
		let userId = AppDelegate.encryptService.keychainService.get(for: .userId)else {
				return
		}
		let padding = String(repeating: "*", count: 128).toBase64()!
		let signString = "\(userId)\(nick)\(token)\(padding)"
		let sign = AppDelegate.encryptService.encrypt(signString)
		UserService().getInfo(with: nick,
													padding: padding,
													sign: sign,
													success: {
														
		}) { (error) in
			
		}
	}
	
	static var currentDelegate: AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
	}
	
	static var currentWindow: UIWindow {
		return currentDelegate.window!
	}
}

