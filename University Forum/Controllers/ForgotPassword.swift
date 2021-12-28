//
//  ForgotPassword.swift
//  University Forum
//
//  Created by Ian Talisic on 21/12/2021.
//

import UIKit
import FirebaseAuth

class ForgotPassword: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        if emailTextField.text!.isEmpty {
            SharedFunc.showError(title: "Error", errMsg: "Please enter your email address.")
        }else if !SharedFunc.isValidEmail(candidate: emailTextField.text!){
            SharedFunc.showError(title: "Error", errMsg: "Please enter a valid email address.")
        }else{
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
                if error == nil {
                    SharedFunc.showSuccess(title: "Forgot Password", message: "Your password reset link has been sent to your email.")
                }else{
                    SharedFunc.showError(title: "Error", errMsg: error!.localizedDescription)
                }
            }
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
