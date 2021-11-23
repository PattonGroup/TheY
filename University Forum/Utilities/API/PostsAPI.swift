//
//  PostsAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 11/11/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit
import AVKit
import AVFoundation


class PostsAPI {
    static let shared: PostsAPI = PostsAPI()
    let collectionName: String = Collection.Posts
    
    func createPost(post: Dictionary<String, Any>) {
        Firestore.firestore().collection(collectionName).addDocument(data: post) { err in
            if let err = err {
                SharedFunc.showError(title: "Error", errMsg: err.localizedDescription)
            } else {
                SharedFunc.showSuccess(title: "Success", message: "You have successfully created a university.")
            }
        }
    }
    
    
    func getAllPosts(completion: @escaping (_ data: [PostResponseModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments() { (querySnapshot, err) in
            print(querySnapshot!.documents.count)
        
            if let _ = err {
                completion([])
            } else {
                var arr: [PostResponseModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(PostResponseModel(snapshot: doc))
                }
                
                completion(arr)
            }
        }
    }
    
    func getPostFromUniversity(id: String, completion: @escaping (_ data: [PostResponseModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).whereField("universityID", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var arr: [PostResponseModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(PostResponseModel(snapshot: doc))
                }
                completion(arr)
            }
        }
    }
    
    func getPost(id: String, completion: @escaping (_ data: [PostResponseModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var arr: [PostResponseModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(PostResponseModel(snapshot: doc))
                }
                completion(arr)
            }
        }
    }
    
    func saveData(post: [String: Any], image: UIImage?, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        if let img = image {
            guard let photoData = img.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            var postData: [String: Any] = post
            let uploadMetaData = StorageMetadata()
            uploadMetaData.contentType = "image/jpeg"
            
            let documentID: String = UUID().uuidString
            let storageRef = storage.reference().child(documentID).child(SharedFunc.generateImageNameBasedOnDate())
            let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { uploadMetaData, error in
                if let error = error {
                    print("ERROR: UPLOAD REF \(String(describing: uploadMetaData))  failed. \(error.localizedDescription)")
                }
                
                storageRef.downloadURL { (url, error) in
                   guard let downloadURL = url else {
                       SharedFunc.showError(title: SharedMessages.failed, errMsg: SharedMessages.failedPostCreation)
                     return completion(false)
                   }
                    
                    print("DOWNLOAD URL:  \(downloadURL)")
                    postData["photoURLPath"] = "\(downloadURL)"
                    print("PHOTO URLPATH:  \(postData["photoURLPath"]!)")
                    Firestore.firestore().collection(self.collectionName).addDocument(data: postData) { error in
                        completion(error == nil)
                    }
                 }
            }
            
//
//            uploadTask.observe(.success) { [self] snapshot in
//
//            }
            
            
            uploadTask.observe(.failure) { snapshot in
                completion(false)
            }
        }else{
            Firestore.firestore().collection(collectionName).addDocument(data: post) { err in
                completion(err == nil)
            }
        }
    }
    
    func uploadTOFireBaseVideo(url: URL,
                                      success : @escaping (String) -> Void,
                                      failure : @escaping (Error) -> Void) {

        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name

        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in

            ur = session.outputURL!
            dispatchgroup.leave()

        }
        dispatchgroup.wait()

        let data = NSData(contentsOf: ur as URL)

        do {

            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            print(error)
        }

        let storageRef = Storage.storage().reference().child("Videos").child(name)
        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if let error = error {
                        failure(error)
                    }else{
                        let strPic:String = SharedFunc.getString(metadata?.name)
                        success(strPic)
                    }
            })
        }
    }
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        try! FileManager.default.removeItem(at: outputURL as URL)
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
    
}

