//
//  SignUpVC.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 3/18/22.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var signUpPresenter: SignUpPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpPresenter = SignUpPresenter(View: self)
        
        setRounded()
        
    }
    func setRounded() {
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.cornerRadius = 35
    }
    func presentError(message: String!){
        let alertOfError = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let actionOfError = UIAlertAction(title: "OK", style: .default){
            (action) in
        }
        alertOfError.addAction(actionOfError)
        self.present(alertOfError, animated: true, completion: nil)
    }
    
   
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        signUpPresenter.checkAuth()
        // go to main screen
    }
    
    
}


