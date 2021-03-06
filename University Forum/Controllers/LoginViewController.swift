//
//  LoginViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 06/09/2021.
//

import UIKit
import Firebase
import MBProgressHUD
import NotificationBannerSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
//    @IBOutlet weak var errorLoginTextfield: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedFunc.applyTextfieldFormatting(emailTextfield)
        SharedFunc.applyTextfieldFormatting(passwordTextfield)
        
//        PostsAPI.shared.getAllPosts { data in }
//
//        let user: [String: Any] = [
//            "email": "ian@gmail.com",
//            "firstname": "Ian",
//            "lastname": "Test",
//            "gender": "Male",
//            "role": "Admin",
//            "universitys_tied": ["1", "2", "3", "4", "5"],
//            "updatedAt": Date()
//        ]
//        UsersAPI.shared.createUser(user: user)
//        UsersAPI.shared.getAllUsers { data in }
    }
        
    @IBAction func loginPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "LoginToView", sender: self)
//
//        if validated() {
//            if let email = emailTextfield.text, let password = passwordTextfield.text {
//
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    if let e = error {
//                        print(e)
//                        SharedFunc.showError(title: "Authentication Error", errMsg: e.localizedDescription)
////                        self.errorLoginTextfield?.text = e.localizedDescription
//                    } else {
//                        self.performSegue(withIdentifier: "LoginToView", sender: self)
//                    }
//
//                }
//
//            }
//        }
  
    }
    
    
    private func highlightErrorTextfield(_ textField: UITextField){
        textField.layer.borderColor = UIColor.systemRed.cgColor
        textField.layer.masksToBounds = true
    }
    
    
    private func validated() -> Bool {
        if emailTextfield.text!.trim().isEmpty {
            highlightErrorTextfield(emailTextfield)
            return false
        }else if !SharedFunc.isValidEmail(candidate: emailTextfield.text!) {
            highlightErrorTextfield(emailTextfield)
            return false
        }else if passwordTextfield.text!.isEmpty {
            highlightErrorTextfield(passwordTextfield)
            return false
        }
        
        return true
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        SharedFunc.applyTextfieldFormatting(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
