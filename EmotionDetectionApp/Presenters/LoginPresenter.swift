//
//  LoginPresenter.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 3/21/22.
//

import Foundation

class LoginPresenter
{
    
    weak var view : LoginVC!
    init(View : LoginVC)
    {
        self.view = View
    }
    
    func checkAuth(){
        
        
        if ValidationManager.shared().isEmptyEmail(email: view.emailTextField.text) == true {
            print("Non empty email")
        }
        else  {
            view.presentError(message: "You must enter an email")
        }
        
        
        if ValidationManager.shared().isValidEmail(email: view.emailTextField.text) == true {
            print("Valid Email")
        } else {
            view.presentError(message: "Enter a valid email")
        }
        
        if ValidationManager.shared().isEmptyPassword(password: view.passwordTextField.text) == true {
            print("Non empty password")
        } else {
            view.presentError(message: "You must enter a password")
        }
        
        if ValidationManager.shared().isValidPassword(password: view.passwordTextField.text) == true {
            print("Vaild Password")
        } else {
            view.presentError(message: "Enter a valid password")
        }
    }
    
    func authForSignUp (email: String, password: String){
        AuthManager.shared().SignInWithFirebase(email: email, password: password)
        if AuthManager.shared().checkUserInfo() == true {
            print("Existing User")
        } else {
            view.presentError(message: "Not existing account")
        }
        
    }
}
