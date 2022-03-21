//
//  ChatPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/15/22.
//

import Foundation
import MessageKit
import SDWebImage
class ChatPresenter {
    
    private var messages = [Message]()
    private var currentUser : Sender!
    private var therapist: Sender!
    private var chatExist: Bool = false
    weak var View: TherapistChatVC!
    init(View: TherapistChatVC) {
        self.View = View
    }
    
    
    
    func getChatId() -> String{
         return "\(ChatFirestoreManager.shared.safeEmail(emailAddress: currentUser.senderId))_\(ChatFirestoreManager.shared.safeEmail(emailAddress: therapist.senderId))"
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
        self.View.clearMessageInputBar()
        if !chatExist {
            print("not exist")
            ChatFirestoreManager.shared.AddNewChat(
                TherapistEmail: self.therapist.senderId,
                UserEmail: self.currentUser.senderId
            ){(result) in
                if result{
                    self.addMessagesToCloud(text: text)
                }
            }
        }
        else{
            print("exist")
            addMessagesToCloud(text: text)
        }
    }
    
    private func createMessageId() -> String? {
        // date, senderID, randomInt
        let safeCurrentEmail = currentUser.senderId
        let dateString = DateFormatter.dateFormatter.string(from: Date())
        let newIdentifier = "\(therapist.senderId)_\(safeCurrentEmail)_\(dateString)\(Int.random(in: 1...1000))"
        return newIdentifier
    }
    
    private func addMessagesToCloud(text: String){
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
                print("result messages")
                self.messages = result
                self.View.reloadMessagesCollection()
                self.View.scrollToLastMessage()

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    //MARK:- Uploading image data
   
    func uploadImageMessage(image : UIImage?){
        if let imageData =  vaildateImageData(image: image) , let fileName = formatImageName(){
            uploadImage(imageData: imageData , fileName: fileName, comletion: ({ result in
                switch result{
                case .success(let url):
                    let message = self.formatImageMessage(url: url, fileName: fileName)
                    self.addImageMessagesToCloud(message: message)
                case .failure(let erorr):
                    print("UploadingErorr \(erorr)")
                    
                }
            }))
        }
        
    }
    
    private func vaildateImageData(image: UIImage?)-> Data? {
        if let imageData = image?.pngData(){
            print(imageData)
            return imageData
        }
        return nil
    }
    
    
    private func formatImageName()-> String?{
        var fileName: String = ""
        if  let messageId = createMessageId(){
          fileName = "photo_message_" + messageId + ".png"
        }
        fileName = ChatFirestoreManager.shared.safeEmail(emailAddress: fileName)
        return fileName
    }
    
    private func formatImageMessage(url: URL, fileName: String) -> Message{
        let placeholder = UIImage(systemName: "plus")!
        let media = Media(url: url,
                          image: nil,
                          placeholderImage: placeholder,
                          size: .zero)

        let message = Message(sender:Sender(senderId: currentUser.senderId, displayName: currentUser.displayName) ,
                              messageId: fileName,
                              sentDate: Date(),
                              kind: .photo(media))
        return message
    }
    
    private func uploadImage(imageData: Data, fileName: String, comletion: @escaping(Result <URL,Error> ) -> Void){
        let chatId = "\(ChatFirestoreManager.shared.safeEmail(emailAddress: currentUser.senderId))_\(ChatFirestoreManager.shared.safeEmail(emailAddress: therapist.senderId))"
            // Upload image
        chatStorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, chatId: chatId ,completion: { result in
                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Photo: \(urlString)")

                    guard let url = URL(string: urlString) else {
                            return
                    }
                    comletion(.success(url))
                case .failure(let error):
                    comletion(.failure(error))
                }
            })
        
    }
    
    private func addImageMessagesToCloud(message: Message){
        let chatId = getChatId()
        ChatFirestoreManager.shared.addNewMessage(newMessage: message, chatId: chatId)
    }
    
//    func DownloadImageMessage(indexPath: IndexPath) -> UIImageView{
//        let message = messages[indexPath.row]
//        switch message.kind {
//        case .photo(let media):
//             let imageUrl = media.url
//            let imageView = UIImageView()
//            imageView.sd_setImage(with: imageUrl, completed: nil)
//            return imageView
//        default:
//            break
//            
//        }
//    }
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
