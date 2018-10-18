//
//  FirebaseService.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging


protocol FirebaseServiceInput: UNUserNotificationCenterDelegate {
	var token: String { get }
}


final class FirebaseService: NSObject {
	
	let gcmMessageIDKey = "gcm.message_id"
	
	var token: String {
		return
		AppDelegate.encryptService.keychainService.get(for: .firebaseToken)!
//		"cJ4nplqWsGc:APA91bEbVQslurJ9_2WmZh5rfU9TLttOTT9SjDC8TDcQ2roL5CaIhlB10P344bsyKw-4myqDqXXh4zV3jfj5mWF6nzyJrVOvN0u84AkycIiX0n6nAWBUF9N1i2QfPw60DlDKAVlCEoOn"
	}
	
	override init() {
		super.init()
		Messaging.messaging().delegate = self
	}
	
}


extension FirebaseService: FirebaseServiceInput {
	
}

extension FirebaseService : UNUserNotificationCenterDelegate {
	
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_ center: UNUserNotificationCenter,
															willPresent notification: UNNotification,
															withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo
		
		// With swizzling disabled you must let Messaging know about the message, for Analytics
		// Messaging.messaging().appDidReceiveMessage(userInfo)
		// Print message ID.
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		// Print full message.
		print(userInfo)
		
		// Change this to your preferred presentation option
		completionHandler([])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
															didReceive response: UNNotificationResponse,
															withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		// Print message ID.
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		// Print full message.
		print(userInfo)
		
		completionHandler()
	}
	
}
// [END ios_10_message_handling]

extension FirebaseService : MessagingDelegate {
	
	// [START refresh_token]
	func messaging(_ messaging: Messaging,
								 didReceiveRegistrationToken fcmToken: String) {
		print("Firebase registration token: \(fcmToken)")
		AppDelegate.encryptService.keychainService.set(fcmToken, for: .firebaseToken)
		
		// TODO: If necessary send token to application server.
		// Note: This callback is fired at each app startup and whenever a new token is generated.
	}
	// [END refresh_token]
	// [START ios_10_data_message]
	// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
	// To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
	func messaging(_ messaging: Messaging,
								 didReceive remoteMessage: MessagingRemoteMessage) {
		print("Received data message: \(remoteMessage.appData)")
	}
	// [END ios_10_data_message]
}
