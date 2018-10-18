//
//  RegisterViewControllerChooseDate.swift
//  MEI
//
//  Created by Alex Lavrinenko on 15.06.2018.
//

import UIKit

protocol RegisterViewControllerChooseDateOutput: class {
	func didSelect(_ date: Date)
}

class RegisterViewControllerChooseDate: UIViewController {
	@IBOutlet weak var datePicker: UIDatePicker!
	
	@IBOutlet weak var saveDateButton: UIButton!
	
	weak var output: RegisterViewControllerChooseDateOutput?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView(self.view)
		self.view.alpha = 0
		datePicker.setValue(UIColor.white, forKey: "textColor")
        let today = NSDate()
        datePicker.maximumDate = today as Date
		UIView.animate(withDuration: 1.5, animations: {
			self.view.alpha = 1
		}) { (finished) in
			print(finished)
		}
		
		setupButton(saveDateButton)
	}
	
	func setupButton(_ button: UIButton) {
		button.layer.cornerRadius = 6
	}
	
	func setupView(_ view: UIView) {
		view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.8)
		view.alpha = 0
	}
	
	@IBAction func saveDateButtonPressed(_ sender: Any) {
		output?.didSelect(datePicker.date)
		UIView.animate(withDuration: 0.45) {
			self.view.alpha = 0
		}
		dismiss(animated: false, completion: nil)
	}
}
