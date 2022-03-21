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
    
    func SignInWithFirebase(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { ( authResult, error) in
                 if let error = error  {
                       print(error.localizedDescription)
                    
                    
                   } else {
                       print("user logged in")
                   }
        }
    }
    func checkUserInfo() -> Bool{
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser?.uid)
            return true
        } else {
            return false
        }
    }
}
