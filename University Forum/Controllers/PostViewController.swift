//
//  PostViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 11/09/2021.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var txtTextView: UITextView!
    @IBOutlet weak var lblWritePost: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        txtTextView.textContainerInset = UIEdgeInsets(top: 12.5, left: 10, bottom: 10, right: 10)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapPhoto(_ sender: Any) {
        showSourceTypeSelection()
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        
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
        
        
        return true
    }
}


extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: false) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)
    }
}
