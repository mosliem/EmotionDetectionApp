//
//  TherapistCharVC.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.isMovingFromParent{
            Presenter.didPressBack()
        }
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
    private func setupInputButton() {
        
        // set the photo Button
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 40, height: 40), animated: false)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .link
        button.onTouchUpInside { [weak self] _ in
            self?.presentImagePicker()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        
        //customize the send button
        messageInputBar.sendButton.image = UIImage(named: "send-button")
        messageInputBar.sendButton.image?.withTintColor(.link)
        
        //customize the input text bar
        messageInputBar.inputTextView.backgroundColor = .systemGroupedBackground
        messageInputBar.inputTextView.layer.cornerRadius = 20
        messageInputBar.inputTextView.clipsToBounds = true
        
    
    }
    
    func currentSender() -> SenderType {
        Presenter.getCurrentUser()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return Presenter.getMessageForItem(indexPath: indexPath)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return Presenter.getMessagesCount()
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return Presenter.getMessageBackgroundColor(message: message)
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
    
    private func presentImagePicker() {
        
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
        
        if message.sender.senderId == Presenter.getCurrentUser().senderId,
           let image = Presenter.loadImageForMessage(message: message)
        {
            imageView.image = image
        }
        else{
            
            switch message.kind
            {
            case .photo(let media):
                imageView.sd_setImage(with: media.url, completed: nil)
            default:
                break
            }
            
        }
    }
    
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        let indexPth = messagesCollectionView.indexPath(for: cell)
        Presenter.didSelectImage(indexPath: indexPth)
    }
    
    func pushPhotoViewVC(url: URL){
        let vc = PhotoViewerViewController(with: url)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


