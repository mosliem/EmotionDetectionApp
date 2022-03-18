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
    private var currentUser = Sender(senderId: "user", displayName: "Will Smith")
    private var therapist = Sender(senderId: "therapist", displayName: "Sara Adam")
    weak var View: TherapistChatVC!
    
    init(View: TherapistChatVC) {
        self.View = View
    }
    
    func getMessagesCount() -> Int {
        return messages.count
    }
    
    func getMessageForItem(indexPath: IndexPath) -> MessageType{
        return messages[indexPath.section]
    }
    
    func getCurrentUser() -> SenderType{
        return currentUser
    }
    
    func getChatName() -> String {
        return therapist.displayName
    }
    func sendButtonPressed(text: String){
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let messageId = createMessageId()
        else {
            return
        }
        
        let message = Message(sender: currentUser,
                              messageId: messageId,
                              sentDate: Date(),
                              kind: .text(text))
        messages.append(message)
        print(message)
        View.reloadMessagesCollection()
    }
    
    func configureDummy(){
        messages.append(Message(sender: therapist, messageId: createMessageId()!, sentDate:Date() , kind: .text("Hello")))
    }
    private func createMessageId() -> String? {
        // date, senderID, randomInt
        let safeCurrentEmail = currentUser.displayName
        
        let dateString = DateFormatter.dateFormatter.string(from: Date())
        let newIdentifier = "\(therapist.senderId)_\(safeCurrentEmail)_\(dateString)"
        
        return newIdentifier
    }
    
}
