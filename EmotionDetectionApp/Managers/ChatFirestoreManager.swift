//
//  chatFirestoreManager.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/16/22.
//

import Foundation
import FirebaseFirestore
import MessageKit

final class ChatFirestoreManager {
    private let db = Firestore.firestore()
    private var LatestSnapshot: QuerySnapshot?
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
    
    func storeUserID(email: String){
        UserDefaults.standard.set(safeEmail(emailAddress: email), forKey: "userId")
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
    
    
    func checkChatExist(userEmail: String , therapistEmail: String, completion: @escaping (Bool) -> Void ){
        
        let chatId =  "\(safeEmail(emailAddress: userEmail))_\(safeEmail(emailAddress: therapistEmail))"
        db.collection("Chats").document(chatId).getDocument { (snap, error) in
            if  snap?.exists == true{
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    
    func AddNewChat(TherapistEmail: String , UserEmail: String , completion: @escaping (Bool) -> Void){
        let chatId =  "\(safeEmail(emailAddress: UserEmail))_\(safeEmail(emailAddress: TherapistEmail))"
        db.collection("Chats").document("\(chatId)").setData(
            [
                "Exist" : true
            ]
        )
        
        db.collection("Users").document(safeEmail(emailAddress: UserEmail)).updateData(
            [
                "channelsId": FieldValue.arrayUnion([chatId])
            ])
        { (error) in
            print(error?.localizedDescription as Any)
        }
        
        
        db.collection("Therapists").document(safeEmail(emailAddress:TherapistEmail)).updateData([
            "channelsId": FieldValue.arrayUnion([chatId])
        ]) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
    
    func addNewMessage(newMessage: Message, chatId: String){
        var message = ""
        switch newMessage.kind {
        
        case .text(let messageText):
            message = messageText
        case .attributedText(_): break
        case .photo(let photoUrl):
            if let url = photoUrl.url?.absoluteString{
                message = url
            }
        case .emoji(_): break
        case .audio(_):break
        case .video(_): break
        case .location(_): break
        case .contact(_): break
        case .linkPreview(_): break
        case .custom(_): break
        }
    
        db.collection("Chats").document(chatId).collection("Messages").document(newMessage.messageId).setData([
            "body": message,
            "sender" : newMessage.sender.senderId,
            "sendDate" : ChatFirestoreManager.dateFormatter.string(from:newMessage.sentDate),
            "kind": newMessage.kind.messageKindString,
            "messageId": newMessage.messageId
        ]){ error in
            guard let error = error else {
                return
            }
            print(error)
           
        }
        
    }
    
    func AddListenerToConversion(chatId: String, completion: @escaping (Result<[Message] , Error>) -> Void){
        db.collection("Chats").document(chatId).collection("Messages").order(by: "sendDate").addSnapshotListener {(messages, error) in
            guard let messages = messages?.documents , error == nil else{
                completion(.failure(error!))
                return
            }
            var allMessages = [Message]()
            var messageKind: MessageKind?
            
            for message in messages {
                let data = message.data()
                if let body = data["body"] as? String ,
                   let sender = data["sender"] as? String ,
                   let sendDate = data["sendDate"] as? String,
                   let kind = data["kind"] as? String,
                   let messageId = data["messageId"] as? String {
                    
                    if kind == "text" {
                        messageKind = .text(body)
                    }
                    else if kind == "photo"{
                        guard let imageUrl = URL(string: body),
                              let placeHolder = UIImage(systemName: "plus") else {
                            return
                        }
                        let media = Media(url: imageUrl,
                                          image: nil,
                                          placeholderImage: placeHolder,
                                          size: CGSize(width: 200, height:200))
                        messageKind = .photo(media)
                    }
                    let date = ChatFirestoreManager.dateFormatter.date(from: sendDate)!
                    allMessages.append(Message(sender:Sender(senderId: sender, displayName: "") , messageId: messageId, sentDate:date, kind:messageKind!))
                }
            }
            completion(.success(allMessages))
        }
    }
    
    func handleMessagesChanges(_ change : DocumentChange){
    
    }
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
}





