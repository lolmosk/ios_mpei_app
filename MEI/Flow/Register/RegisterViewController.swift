//
//  RegisterViewController.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import UIKit
import DropDown


class RegisterStepOneViewController: UIViewController {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var middleTextField: UITextField!
	@IBOutlet weak var lastTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var questionTextField: UITextField!
	@IBOutlet weak var answerTextField: UITextField!
	
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var selectDateButton: UIButton!
	
	let dropDown = DropDown()
	
	var userRegisterModel: UserReisterModel = UserReisterModel()
	
	let registerService: RegisterServiceInput = RegisterService()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTextFields()
		setupDrowDownTextField(for: questionTextField)
		#if DEBUG
		fillTestData()
		#endif
		setupButton(nextButton, isEnabled: userRegisterModel.isComplete)
		DropDown.startListeningToKeyboard()
		registerService.set(output: self)
		setup(navigation: navigationItem)
		setupButton(nextButton)
		setupButton(selectDateButton)
	}
    
    var imageViewBackground: UIImageView!
    
    override func loadView() {
        super.loadView()
        
        // get the correct image out of your assets cataloge
        let image = UIImage(named: "background")!
        
        // initialize the value of imageView with a CGRectZero, resize it later
        self.imageViewBackground = UIImageView(frame: self.view.frame)
        
        // set the appropriate contentMode and add the image to your imageView property
        self.imageViewBackground.contentMode = .scaleAspectFill
        self.imageViewBackground.image = image
        //self.view.backgroundColor = UIColor(patternImage: image)
        
        // add the imageView to your view hierarchy
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: self.imageViewBackground)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //set the frame of your imageView here to automatically adopt screen size changes (e.g. by rotation or splitscreen)
        self.imageViewBackground.frame = self.view.bounds
        
        
    }
	
	func fillTestData() {
		nameTextField.text = "Имя"
		middleTextField.text = "Отчество"
		lastTextField.text = "Фамилия"
		questionTextField.text = "Вопрос"
		answerTextField.text = "Ответ"
		emailTextField.text = "sddfsfsf@mail.ru"
		
		userRegisterModel.name = nameTextField.text
		userRegisterModel.middlename = middleTextField.text
		userRegisterModel.lastname = lastTextField.text
		userRegisterModel.question = questionTextField.text
		userRegisterModel.answer = answerTextField.text
		userRegisterModel.email = emailTextField.text
	}
	
	// MARK: - Setup UI
	func setupTextFields() {
		setup(nameTextField)
		setup(middleTextField)
		setup(lastTextField)
		setup(emailTextField)
		setup(questionTextField)
		setup(answerTextField)
	}
	
	func setupButton(_ button: UIButton) {
		button.layer.cornerRadius = 6
	}
	
	func setup(navigation item: UINavigationItem) {
		navigationItem.title = "Регистрация"
	}
	
	func setupDrowDownTextField(for textField: UITextField) {
		dropDown.anchorView = textField
		dropDown.topOffset = CGPoint(x: 0, y: -textField.frame.height)
		dropDown.direction = .top
		dropDown.dataSource = ["Девичья фамиля вашей матери?", "Кличка вашего первого питомца?", "Номер школы, которую вы закончили?", "Имя лучшего друга детства?", "Куда вы впервые полетели на самолете?"]
		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			textField.text = item
			self.userRegisterModel.question = item
			textField.resignFirstResponder()
		}
		let beganEditing = #selector(RegisterStepOneViewController.textFieldDidBeganEditing(_:))
		textField.addTarget(self, action: beganEditing, for: .editingDidBegin)
		
		let endEditingAction = #selector(RegisterStepOneViewController.textFieldDidEndEditing(_:))
		textField.addTarget(self, action: endEditingAction, for: .editingDidEnd)
	}
	
	func setup(_ field: UITextField) {
		let action = #selector(RegisterStepOneViewController.textFieldDidChange(_:))
		field.addTarget(self, action: action, for: .editingChanged)
	}
	
	func setupButton(_ nextButton: UIButton, isEnabled: Bool) {
		nextButton.isEnabled = isEnabled
	}
	
	@objc func textFieldDidBeganEditing(_ textField: UITextField) {
		dropDown.show()
	}
	
	@objc func textFieldDidEndEditing(_ textField: UITextField) {
		dropDown.hide()
	}
			
	@objc func textFieldDidChange(_ textField: UITextField) {
		defer {
				setupButton(nextButton, isEnabled: userRegisterModel.isComplete)
		}
		if textField == nameTextField {
			return userRegisterModel.name = textField.text
		}
		if textField == middleTextField {
			return userRegisterModel.middlename = textField.text
		}
		if textField == lastTextField {
			return userRegisterModel.lastname = textField.text
		}
		if textField == emailTextField {
			return userRegisterModel.email = textField.text
		}
		if textField == questionTextField {
			dropDown.hide()
			return userRegisterModel.question = textField.text
		}
		if textField == answerTextField {
			return userRegisterModel.answer = textField.text
		}
	}
	
	@IBAction func nextStepButtonPressed(_ sender: Any) {
		registerService.register(with: userRegisterModel,
														 publicKey: try! AppDelegate.encryptService.publicKey.base64String(),
														 firebaseToken: AppDelegate.firebaseService.token)
	}
	
	@IBAction func chooseDateButtonPressed(_ sender: Any) {
		if let vc = R.storyboard.auth.registerViewControllerChooseDate() {
			vc.output = self
			vc.modalPresentationStyle = .overCurrentContext
			present(vc, animated: false, completion: nil)
		}
	}
    
    @IBAction func quesionHintButtonPressed(_ sender: Any) {
        if let vch = R.storyboard.auth.registerViewControllerQuestionHint() {
            vch.modalPresentationStyle = .overCurrentContext
            present(vch, animated: false, completion: nil)
        }
    }
}

extension RegisterStepOneViewController: RegisterViewControllerChooseDateOutput {
	func didSelect(_ date: Date) {
		let formatter = DateFormatter(withFormat: "dd.MM.yyyy", locale: "ru-ru")
		
		selectDateButton.setTitle("\(formatter.string(from: date))(изменить)", for: .normal)
		userRegisterModel.birthDate = formatter.string(from: date)
		setupButton(nextButton, isEnabled: userRegisterModel.isComplete)
	}
}

extension RegisterStepOneViewController: RegisterServiceOutput {
	func didRegister(_ sign: String) {
		print(sign)
	}
	
	func didRecieveError(_ error: Error) {
		let alertVc = UIAlertController.error(with: "Что то пошло не так. Пожалуйста, повторите запрос позже")
		present(alertVc, animated: true, completion: nil)
	}
}
