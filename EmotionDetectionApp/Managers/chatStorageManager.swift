//
//  chatStorageManager.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/20/22.
//

import Foundation
import FirebaseStorage

class chatStorageManager{
    static let shared = chatStorageManager()

        private init() {}

        private let storage = Storage.storage().reference()

        public typealias UploadPictureCompletion = (Result<String, Error>) -> Void

        // Uploads picture to firebase storage and returns completion with url string to download
//        public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
//            print("ref\(storage)")
//            storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
//                guard let strongSelf = self else {
//                    return
//                }
//
//                guard error == nil else {
//                    // failed
//                    print("failed to upload data to firebase for picture")
//                    print(error)
//                    completion(.failure(StorageErrors.failedToUpload))
//                    return
//                }
//
//                strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
//                    guard let url = url else {
//                        print("Failed to get download url")
//                        completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                        return
//                    }
//
//                    let urlString = url.absoluteString
//                    print("download url returned: \(urlString)")
//                    completion(.success(urlString))
//                })
//            })
//        }

        // Upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String,chatId: String, completion: @escaping UploadPictureCompletion) {
            print(storage)
            storage.child("\(chatId)/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
                guard error == nil else {
                    // failed
                    print("failed to upload data to firebase for picture")
                    completion(.failure(StorageErrors.failedToUpload))
                    return
                }

                self?.storage.child("\(chatId)/\(fileName)").downloadURL(completion: { url, error in
                    guard let url = url else {
                        print("Failed to get download url")
                        completion(.failure(StorageErrors.failedToGetDownloadUrl))
                        return
                    }

                    let urlString = url.absoluteString
                    print("download url returned: \(urlString)")
                    completion(.success(urlString))
                })
            })
       }

        public enum StorageErrors: Error {
            case failedToUpload
            case failedToGetDownloadUrl
        }

        public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
            let reference = storage.child(path)

            reference.downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                completion(.success(url))
            })
        }
}
