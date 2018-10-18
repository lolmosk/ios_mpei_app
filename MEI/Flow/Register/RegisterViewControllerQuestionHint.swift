//
//  RegisterViewControllerQuestionHint.swift
//  MEI
//
//  Created by lolmosk on 20/06/2018.
//

import UIKit

class RegisterViewControllerQuestionHint: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var hintText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(self.view)
        self.view.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.view.alpha = 1
        }) { (finished) in
            print(finished)
        }
        setupButton(okButton)
        setupText(hintText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func okButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.45) {
            self.view.alpha = 0
        }
        dismiss(animated: false, completion: nil)
    }
    
    func setupButton(_ button: UIButton) {
        button.layer.cornerRadius = 6
    }
    
    func setupText(_ text: UITextView) {
        text.textColor = UIColor.white
        text.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        text.alpha = 1
    }
    
    func setupView(_ view: UIView) {
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.8)
        view.alpha = 0
    }

}
