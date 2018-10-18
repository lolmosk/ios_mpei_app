//
//  AuthViewController.swift
//  MEI
//
//  Created by Alex Lavrinenko on 08.06.2018.
//

import UIKit
import SwiftyRSA


class AuthViewController: UIViewController {
	
	// MARK: - UI elements
	@IBOutlet weak var logoImageView: UIImageView!
	
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginTextField: UITextField!
	
	@IBOutlet weak var logInButton: UIButton!
	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var foggotPasswordButton: UIButton!
	
	// MARK: - Logic
	let authService: AuthServiceInput
	var userAuthModel: UserAuthModel
	
	// MARK: - Lifecycle
	required init?(coder aDecoder: NSCoder) {
		self.authService = AuthService()
		self.userAuthModel = UserAuthModel()
		super.init(coder: aDecoder)
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		authService.set(output: self)
		setup(logIn: loginTextField)
		setup(password: passwordTextField)
		setup(navigation: navigationItem)
		setupButton(logInButton)
		#if DEBUG
		setDefaultLogIn()
		#endif
	}
	
	func setDefaultLogIn() {
		loginTextField.text = "PikaninMM"
		passwordTextField.text = "aJ2rf0o9"
		userAuthModel.login =	loginTextField.text
		userAuthModel.password =	passwordTextField.text
	}
	
	// MARK: - Setup UI
	func setup(logIn field: UITextField) {
		let action = #selector(AuthViewController.loginFieldDidChange(_:))
		field.addTarget(self, action: action, for: .editingChanged)
	}
	
	func setup(password field: UITextField) {
		let action = #selector(AuthViewController.passwordFieldDidChange(_:))
		field.addTarget(self, action: action, for: .editingChanged)
	}
	
	func setupButton(_ button: UIButton) {
		button.layer.cornerRadius = 6
	}
	
	func setup(navigation item: UINavigationItem) {
		navigationItem.title = "Авторизация"
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		button.setImage(#imageLiteral(resourceName: "back"), for: .normal)
		let barButtonItem = UIBarButtonItem(customView: button)
		navigationItem.backBarButtonItem = barButtonItem
	}
	
	@objc func backPressed(_ sender: UIBarButtonItem) {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Actions
	@objc func loginFieldDidChange(_ textField: UITextField) {
		self.userAuthModel.login = textField.text
	}
	
	@objc func passwordFieldDidChange(_ textField: UITextField) {
		self.userAuthModel.password = textField.text
	}
	
	@IBAction func logInButtonPressed(_ sender: Any) {
		guard userAuthModel.isFilled else {
			present(UIAlertController.error(with: "Заполните оба поля"),
							animated: true, completion: nil)
			return
		}
		do {
			let s = try EncryptService()
			let publicKey = try AppDelegate.encryptService.publicKey.pemString()
			let publicbase64 = publicKey.toBase64()!
			authService.logIn(with: userAuthModel,
												publicKey: publicbase64,
												firebaseToken: AppDelegate.firebaseService.token)
		} catch {
			print(error)
		}
	}
	@IBAction func registerButtonPressed(_ sender: Any) {
		guard let vc = R.storyboard.auth.registerStepOneViewController() else {
			return
		}
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func foggotButtonPressed(_ sender: Any) {
		
	}
}


// MARK: - AuthServiceOutput
extension AuthViewController: AuthServiceOutput {
	func didLogIn(_ authResponse: AuthResult) {
		let verified = AppDelegate.encryptService.verify(authResponse.sign,
																										 clearMessage: authResponse.clearMessage)
		guard verified else {
			let alertVc = UIAlertController.error(with: "Что то пошло не так. Пожалуйста, повторите запрос позже")
			present(alertVc, animated: true, completion: nil)
			return
		}
		AppDelegate.encryptService.keychainService.set(authResponse.login, for: .nick)
		AppDelegate.encryptService.keychainService.set(String(authResponse.userId), for: .userId)
		let navVc = R.storyboard.main.mainNavigationController()
		AppDelegate.currentWindow.rootViewController = navVc
		
		authService.quickLogIn(with: authResponse.login, firebaseToken: AppDelegate.encryptService.keychainService.get(for: .firebaseToken)!)
	}
	
	func didQuickLogIn(_ authResponse: QuickAuthResult) {
		
	}
	
	func didRecieveError(_ error: Error) {
		let alertVc = UIAlertController.error(with: "Что то пошло не так. Пожалуйста, повторите запрос позже")
		present(alertVc, animated: true, completion: nil)
	}
}

