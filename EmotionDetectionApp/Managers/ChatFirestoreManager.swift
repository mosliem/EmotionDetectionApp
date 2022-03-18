//
//  chatFirestoreManager.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/16/22.
//

import Foundation
import Firebase


final class ChatFirestoreManager {
    private let db = Firestore.firestore()
    public static var shared = ChatFirestoreManager()
    
    private init(){}
    func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
    func getCurrentUserEmail() -> String {
        return "mosliem191299@gmail.com"
        // guard let currentUserEmail == Auth.auth().currentUser?.email else{
        //        return
        //       }
        //      return currentUserEmail
    }
    
    func addNewUserToCloud(){
        db.collection("Users").document(safeEmail(emailAddress: "mosliem191299@gmail.com")).setData([
            "username": "Sliem",
            "DateOfBirth":"19/12/1999",
            "profileLink":"Null",
            "journal" : []
        ])
        
    }
    
    func getAvailableTherapist(completion: @escaping(Result<[AvailableTherapistModel],Error>) -> Void){
        db.collection("Therapists").getDocuments { (querySnap, error) in
            if let error = error{
                print(error)
            }
            if let documents = querySnap?.documents{
                
                var Therapist: [AvailableTherapistModel] = []
                for doc in documents {
                    Therapist.append(AvailableTherapistModel(name: doc["name"] as! String, email: doc["email"] as! String , Bio: doc["Bio"] as! String))
                }
                completion(.success(Therapist))
            }
        }
    }
    
    
    
    func AddNewChat(TherapistEmail: String , UserEmail: String){
        let chatID = "\(UserEmail)_\(TherapistEmail)"
        print(chatID)
        db.collection("Chats").document("\(chatID)").setData([
            "Exist" : true
        ])
        db.collection("Users").document(UserEmail).updateData([
            "ChannelsId": FieldValue.arrayUnion([chatID])
        ]) { (error) in
        }
    }
    
    
}





