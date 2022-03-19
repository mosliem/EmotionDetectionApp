//
//  ChatPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/15/22.
//

import Foundation
import MessageKit

class ChatPresenter {
    
    private var messages = [Message]()
    private var currentUser : Sender!
    private var therapist: Sender!
    private var chatExist: Bool = false
    weak var View: TherapistChatVC!
    init(View: TherapistChatVC) {
        self.View = View
    }
    
    
    //MARK:- MessagesInfo
    func getMessagesCount() -> Int {
        return messages.count
    }
    
    func getMessageForItem(indexPath: IndexPath) -> MessageType{
        return messages[indexPath.section]
    }
    
    func getCurrentUser() -> SenderType {
        return currentUser
    }
    
    func getChatName() -> String {
        return therapist.displayName
    }
    
    func checkIfChatExist(){
        print("chat checking")
        ChatFirestoreManager.shared.checkChatExist(
            userEmail: currentUser.senderId,
            therapistEmail: therapist.senderId
        )  {(exist) in
            if exist{
                self.chatExist = true
            }
            
        }
    }
    
    func sendButtonPressed(text: String){
        if !chatExist {
            print("not exist")
            ChatFirestoreManager.shared.AddNewChat(
                TherapistEmail: self.therapist.senderId,
                UserEmail: self.currentUser.senderId
            ){(result) in
                if result{
                    self.addTextMessagesToCloud(text: text)
                }
            }
        }
        else{
            print("exist")
            addTextMessagesToCloud(text: text)
        }
    }
    
    private func createMessageId() -> String? {
        // date, senderID, randomInt
        let safeCurrentEmail = currentUser.senderId
        let dateString = DateFormatter.dateFormatter.string(from: Date())
        let newIdentifier = "\(therapist.senderId)_\(safeCurrentEmail)_\(dateString)\(Int.random(in: 1...1000))"
        return newIdentifier
    }
    
    private func addTextMessagesToCloud(text: String){
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let messageId = createMessageId()
        else {
            return
        }
        let chatId = "\(ChatFirestoreManager.shared.safeEmail(emailAddress: currentUser.senderId))_\(ChatFirestoreManager.shared.safeEmail(emailAddress: therapist.senderId))"
        
        let message = Message(sender: currentUser,
                              messageId: messageId,
                              sentDate: Date(),
                              kind: .text(text))
        ChatFirestoreManager.shared.addNewMessage(newMessage: message,chatId: chatId)
    }
     func getAllMessages(){
        let chatId = "\(ChatFirestoreManager.shared.safeEmail(emailAddress: currentUser.senderId))_\(ChatFirestoreManager.shared.safeEmail(emailAddress: therapist.senderId))"
        
        ChatFirestoreManager.shared.AddListenerToConversion(chatId: chatId) { (result) in
            switch result{
            
            case .success(let result):
                print(result)
                self.messages = result
                self.View.reloadMessagesCollection()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    //MARK:- users Data
    func setTherapistId(therapistEmail: String , therapistName: String){
        therapist = Sender(senderId: therapistEmail, displayName: therapistName)
    }
    
    func setUserData(){
        print("userData")
        let senderId = UserDefaults.standard.object(forKey: "userEmail") as? String ?? "help"
        currentUser = Sender(senderId: senderId, displayName: "Me")
    }
}
