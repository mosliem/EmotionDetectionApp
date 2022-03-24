//
//  LoginVC.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 3/21/22.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var loginPresenter: LoginPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter = LoginPresenter(View: self)
        // Do any additional setup after loading the view.
    }
    
    
    func presentError(message: String!){
        let alertOfError = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let actionOfError = UIAlertAction(title: "OK", style: .default){
            (action) in
        }
        alertOfError.addAction(actionOfError)
        self.present(alertOfError, animated: true, completion: nil)
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        loginPresenter.checkAuth()
        loginPresenter.authForLogin(email: emailTextField.text!, password: passwordTextField.text!)
    }
}
