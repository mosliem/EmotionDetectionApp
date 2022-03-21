//
//  AuthManager.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/12/22.
//

import Foundation
import FirebaseAuth
class AuthManager{
    //Mark:- Singletone
    private static let sharedInstance = AuthManager()
    
    class func shared()-> AuthManager{
        return AuthManager.sharedInstance
    }
    
    func createUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (aurhResult, error) in
            if let error = error  {
                print(error.localizedDescription)
            } else {
                print("User Created")
            }
        }
        
    }
    
}
