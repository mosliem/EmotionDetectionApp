//
//  ValidationManager.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 3/21/22.
//

import Foundation

class ValidationManager{
    //Mark:- Singletone
    private static let sharedInstance = ValidationManager()
    
    class func shared()-> ValidationManager{
        return ValidationManager.sharedInstance
    }
    
    
    func isEmptyEmail(email: String?)-> Bool{
        guard let email = email?.trimmed, !email.isEmpty else{
            return false
        }
        return true
    }
    
    func isValidEmail(email: String?)-> Bool{
        guard email != nil else {return false}
        let regEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let pred = NSPredicate(format:"SELF MATCHES[c] %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(password: String?)-> Bool{
        guard password != nil else {return false}
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
    func isEmptyPassword(password: String?)-> Bool{
        guard let password = password, !password.isEmpty else{
            return false
        }
        return true
    }
    
    func isEmptyName(name: String?)-> Bool{
        guard let name = name, !name.isEmpty else{
            return false
        }
        return true
    }
}
