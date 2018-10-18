//
//  UIAlertController+Helper.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import UIKit

extension UIAlertController {
	static func error(with text: String) -> UIAlertController {
		let alertController = UIAlertController(title: "Ошибка", message: text, preferredStyle: UIAlertControllerStyle.alert)
		alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		return alertController
	}
}
