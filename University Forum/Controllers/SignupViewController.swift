//
//  SignupViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 23/10/2021.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedFunc.applyTextfieldFormatting(fullNameTextfield)
        SharedFunc.applyTextfieldFormatting(emailTextfield)
        SharedFunc.applyTextfieldFormatting(passwordTextfield)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSignup(_ sender: Any) {
        self.view.endEditing(true)
        
        self.performSegue(withIdentifier: "SignupToShowMain", sender: self)
        
//        if validated() {
//            if let email = emailTextfield.text, let password = passwordTextfield.text {
//                
//                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                    if let e = error {
//                        print(e)
//                        SharedFunc.showError(errMsg: e.localizedDescription)
//                    } else {
//                        self.performSegue(withIdentifier: "SignupToShowMain", sender: self)
//                    }
//                }
//            }
//        }
        
    }
    
    @IBAction func didTapSignin(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    private func highlightErrorTextfield(_ textField: UITextField){
        textField.layer.borderColor = UIColor.systemRed.cgColor
        textField.layer.masksToBounds = true
    }
    
    
    private func validated() -> Bool {
        if fullNameTextfield.text!.trim().isEmpty {
            highlightErrorTextfield(fullNameTextfield)
            return false
        }else if emailTextfield.text!.trim().isEmpty {
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


extension SignupViewController: UITextFieldDelegate {
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
