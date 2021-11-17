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
    static let collectionName: String = Collection.Posts
    
    func createPost(post: Dictionary<String, Any>) {
        Firestore.firestore().collection(UsersAPI.collectionName).addDocument(data: post) { err in
            if let err = err {
                SharedFunc.showError(title: "Error", errMsg: err.localizedDescription)
            } else {
                SharedFunc.showSuccess(title: "Success", message: "You have successfully created a university.")
            }
        }
    }
    
    
    func getAllPosts(completion: @escaping (_ data: [Any]) -> ()) {
        let db = Firestore.firestore()
        db.collection(Collection.Posts).getDocuments() { (querySnapshot, err) in
            print(querySnapshot)
            if let _ = err {
                completion([])
            } else {
                completion(querySnapshot!.documents)
            }
        }
    }
    
    func getPost(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
        let db = Firestore.firestore()
        db.collection(Collection.Posts).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func saveData(post: [String: Any], image: UIImage, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        guard let photoData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        let documentID: String = UUID().uuidString
        let storageRef = storage.reference().child(documentID).child(documentID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { uploadMetaData, error in
            if let error = error {
                print("ERROR: UPLOAD REF \(String(describing: uploadMetaData))  failed. \(error.localizedDescription)")
            }
        }
        
        
        uploadTask.observe(.success) { snapshot in
            print("Upload to firevase storage was successful")
            
            let ref = db.collection(PostsAPI.collectionName).document(documentID).collection("details").document(documentID)
            ref.setData(post) { error in
                guard error == nil else {
                    print("failed")
                    return completion(false)
                }
                print("success")
            }
            
            
            
            completion(true)
        }
        
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Error: Upload task for file \(documentID) failed, in spot \(documentID)")
            }
            completion(true)
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

