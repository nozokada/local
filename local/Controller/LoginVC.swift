//
//  LoginVC.swift
//  local
//
//  Created by Nozomi Okada on 12/12/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: MainTextField!
    @IBOutlet weak var passwordTextField: MainTextField!
    @IBOutlet weak var loginButton: MainButton!
    @IBOutlet weak var alertMessageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        alertMessageLabel.text = ""
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                alertMessageLabel.text = "Please fill in all fields."
                return
        }
        loginButton.disable()
        Auth.auth().signIn(withEmail: email, password: password) { (AuthResult, error) in
            if let error = error {
                self.alertMessageLabel.text = error.localizedDescription
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.loginButton.enable()
        }
    }
}
