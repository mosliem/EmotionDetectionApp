//
//  TherapistCharVC.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class TherapistChatVC: MessagesViewController {
    
    var Presenter: ChatPresenter!
    var therapistEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Presenter = ChatPresenter(View: self)
        configureMessageDelegate()
        setupInputButton()
        Presenter.setTherapistId(therapistEmail: therapistEmail!, therapistName: self.title!)
        Presenter.setUserData()
        Presenter.checkIfChatExist()
        Presenter.getAllMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    private func configureMessageDelegate(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
    }
    
    func reloadMessagesCollection(){
        messagesCollectionView.reloadData()
    }
    
}

extension TherapistChatVC : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate,MessageCellDelegate {
    func currentSender() -> SenderType {
        Presenter.getCurrentUser()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return Presenter.getMessageForItem(indexPath: indexPath)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return Presenter.getMessagesCount()
    }
}

extension TherapistChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        Presenter.sendButtonPressed(text: text)
    }
    
    func clearMessageInputBar(){
        messageInputBar.inputTextView.text = ""
    }
    
    func scrollToLastMessage(){
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

extension TherapistChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .green
        button.onTouchUpInside { [weak self] _ in
            self?.presentImagePicker()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        
    }
    
    private func presentImagePicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.editedImage] as? UIImage
        Presenter.uploadImageMessage(image: image)
        
    }
    
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let media):
             let imageUrl = media.url
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
            
        }
    }
}
