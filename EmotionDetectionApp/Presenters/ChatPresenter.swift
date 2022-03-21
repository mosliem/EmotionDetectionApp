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
    private let imageCache = NSCache<NSString, UIImage>()
    weak var View: TherapistChatVC!
    
    init(View: TherapistChatVC) {
        self.View = View
    }
    
    func didPressBack(){
        ChatFirestoreManager.shared.removeListener()
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
        ){(exist) in
            if exist{
                self.chatExist = true
                print(self.chatExist)
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
    
    //Add new text messages to cloud
    ///setup the message object and message id
    ///passing to the cloud
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
    
    //retrieve messages from the cloud
    ///adding listener to converstion
    func getAllMessages(){
        print("startListening")
        let chatId = "\(ChatFirestoreManager.shared.safeEmail(emailAddress: currentUser.senderId))_\(ChatFirestoreManager.shared.safeEmail(emailAddress: therapist.senderId))"
        
        ChatFirestoreManager.shared.AddListenerToConversion(chatId: chatId) { (result) in
            switch result{
            
            case .success(let result):
                self.messages = result         //updating messages
                self.didEndGettingMessages()  //reload the view
            
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    //specify the color of the message bubble for the two users
    
    func getMessageBackgroundColor(message: MessageType) -> UIColor{
        
        let sender = message.sender
        if sender.senderId == currentUser?.senderId {
            switch message.kind {
            case .text:
                return .link
            case .photo:
                return .clear
            default:
                return .link
            }
            
        }
        return .secondarySystemBackground
    }
    
    private func didEndGettingMessages(){
        self.View.reloadMessagesCollection()
        self.View.scrollToLastMessage()
    }
    
    //MARK:- Uploading image data and Caching
    
    //handling the process of uploading photos to cloud and caching it
    
    func uploadImageMessage(image : UIImage?){
        
        if let imageData =  vaildateImageData(image: image) , let fileName = formatImageName() {
            
            cacheImage(fileName: fileName , image: image!)
            addCachedMessageToView(fileName: fileName)
            
            uploadImage(imageData: imageData , fileName: fileName, comletion: ({ result in
                
                switch result
                {
                case .success(let url):
                    let message = self.formatImageMessage(url: url, fileName: fileName)
                    self.addImageMessagesToCloud(message: message)
                    
                case .failure(let erorr):
                    print("UploadingErorr \(erorr)")
                }
                
            }))
        }
    }
    
    //cache the image to decrease the network load
    private func cacheImage(fileName: String, image:UIImage){
        ImageCache.shared.setObject(image, forKey: fileName as NSString)
    }
    
    func getCachedImage(fileName: String) -> UIImage? {
        guard let image = ImageCache.shared.object(forKey: fileName as NSString) else{
            return nil
        }
        return image
    }
    
    //retrieving the image from the cache
    /// if image is not in the cache the returned value will fire an event to download it from the cloud
    
    func loadImageForMessage(message: MessageType) -> UIImage?{
        
        if let image =  getCachedImage(fileName: message.messageId){
            return image
        }
        return nil
    }
    
    // creating a message for the retrieved image from the cache
    
    private func addCachedMessageToView(fileName: String){
        
        if let image = ImageCache.shared.object(forKey: fileName as NSString){
            
            let placeHolder = UIImage(systemName: "plus")
            
            let mediaItem = Media(
                url: URL(string:fileName),
                image: image,
                placeholderImage: placeHolder! ,
                size: CGSize(width: 200, height:180)
            )
            
            let message = Message(sender: Sender(senderId: currentUser.senderId, displayName: currentUser.displayName), messageId: fileName, sentDate: Date(), kind: .photo(mediaItem))
            messages.append(message)
            View.reloadMessagesCollection()
            View.scrollToLastMessage()
        }
        
    }
    
    
    //MARK:-  photo Uplaoding helpers
    
    private func vaildateImageData(image: UIImage?)-> Data? {
        
        if let imageData = image?.jpegData(compressionQuality: 0.1) {
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
    
    
    //MARK:-  Tapping Actions
    
    func didSelectImage(indexPath: IndexPath?){
        
        guard let indexPath = indexPath else{
            return
        }
        
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            
            if let url = media.url
            {
                View.pushPhotoViewVC(url: url)
            }
        default:
            break
        }
        
    }
    
    //MARK:- users Data
    func setTherapistId(therapistEmail: String , therapistName: String){
        therapist = Sender(senderId: therapistEmail, displayName: therapistName)
    }
    
    func setUserData(){
        
        let senderId = UserDefaults.standard.object(forKey: "userEmail") as? String ?? "help"
        currentUser = Sender(senderId: senderId, displayName: "Me")
        
    }
}
