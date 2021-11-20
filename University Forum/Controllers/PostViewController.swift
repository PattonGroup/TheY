//
//  PostViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 11/09/2021.
//

import UIKit
import MBProgressHUD

class PostViewController: UIViewController {
    @IBOutlet weak var txtTextView: UITextView!
    @IBOutlet weak var lblWritePost: UILabel!
    @IBOutlet weak var txtTextViewHC: NSLayoutConstraint!
    @IBOutlet weak var imgPhotoPost: UIImageView!
    
    
    var imagePicker = UIImagePickerController()
    var universityID: String = ""
    var image: UIImage? {
        didSet {
            imgPhotoPost.isHidden = image == nil
            imgPhotoPost.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        txtTextView.textContainerInset = UIEdgeInsets(top: 12.5, left: 10, bottom: 10, right: 10)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnywhere))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapAnywhere(){
        self.view.endEditing(true)
    }

    @IBAction func didTapPhoto(_ sender: Any) {
        self.view.endEditing(true)
        showSourceTypeSelection()
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        self.view.endEditing(true)
    
        let post: [String: Any] = [
            "postAt": Date(),
            "userID": "2",
            "universityID": universityID,
            "postDescription": SharedFunc.getString(txtTextView.text),
            "videoURLPath": "",
            "photoURLPath": "",
            "status": "Pending"
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        PostsAPI.shared.saveData(post: post, image: self.image) { success in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if success {
                SharedFunc.showSuccess(title: SharedMessages.success, message: SharedMessages.successPostCreation)
            }else{
                SharedFunc.showError(title: SharedMessages.failed, errMsg: SharedMessages.failedPostCreation)
            }
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    func showSourceTypeSelection(){
        let title = "Source Type"
        let message = "Please select photo source type."
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { _ in
            self.takeAPicture()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.selectPictureFromPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func takeAPicture(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func selectPictureFromPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let txt: String = String((textView.text as NSString).replacingCharacters(in: range, with: text))
        lblWritePost.isHidden = txt.count > 0
        
        textView.isScrollEnabled = false
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.infinity))
        txtTextViewHC.constant = size.height + 30
        textView.isScrollEnabled = true
        
        return true
    }
}


extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: false) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.image = image
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)
    }
}
