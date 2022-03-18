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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageDelegate()
        Presenter = ChatPresenter(View: self)
        Presenter.configureDummy()
        setupInputButton()
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
    
//    func setupSendButton(){
//        let rightButton = InputBarButtonItem()
//        let sendImage = UIImage(named: "send_button.png")
//        rightButton.setImage(sendImage, for: UIControl.State.normal)
//
//        messageInputBar.setRightStackViewWidthConstant(to: CGFloat(34.0), animated: true)
//
//        messageInputBar.setStackViewItems([rightButton], forStack: .right, animated: false)
//
//    }
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



extension TherapistChatVC: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        Presenter.sendButtonPressed(text: text)
    }
    
}




extension TherapistChatVC {
    
    private func setupInputButton() {
          let button = InputBarButtonItem()
          button.setSize(CGSize(width: 35, height: 35), animated: false)
          button.setImage(UIImage(systemName: "paperclip"), for: .normal)
          button.onTouchUpInside { [weak self] _ in
              self?.presentInputActionSheet()
          }
          messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
          messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
      }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {  _ in

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    
private func presentPhotoInputActionsheet() {
            let actionSheet = UIAlertController(title: "Attach Photo",
                                                message: "Where would you like to attach a photo from",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in

                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                picker.allowsEditing = true
                self?.present(picker, animated: true)

            }))
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in

                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                picker.allowsEditing = true
                self?.present(picker, animated: true)

            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            present(actionSheet, animated: true)
        }
}
