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
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var lblForgotPassword: UILabel!
    //    @IBOutlet weak var errorLoginTextfield: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedFunc.applyTextfieldFormatting(emailTextfield)
        SharedFunc.applyTextfieldFormatting(passwordTextfield)
        
        lblForgotPassword.isUserInteractionEnabled = true
        lblForgotPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapForgotPassword)))
        
        
        let attrib = NSMutableAttributedString(string: "Forgot Password")
        attrib.addAttributes([.foregroundColor: UIColor.systemBlue, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.systemBlue], range: NSRange(location: 0, length: attrib.string.count))
        lblForgotPassword.attributedText = attrib
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func didTapForgotPassword(){
        let sb = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ForgotPassword")
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func loginPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if validated() {
            if let email = emailTextfield.text, let password = passwordTextfield.text {

                MBProgressHUD.showAdded(to: self.view, animated: true)
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    print("ID: \(SharedFunc.getUserID())")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if let e = error {
                        print(e)
                        SharedFunc.showError(title: "Authentication Error", errMsg: e.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: "LoginToView", sender: self)
                    }
                }
            }
        }

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
