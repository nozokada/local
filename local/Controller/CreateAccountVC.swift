//
//  CreateAccountVC.swift
//  local
//
//  Created by Nozomi Okada on 12/13/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountVC: UIViewController {

    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: MainTextField!
    @IBOutlet weak var passwordTextField: MainTextField!
    @IBOutlet weak var usernameTextField: MainTextField!
    @IBOutlet weak var createAccountButton: MainButton!
    @IBOutlet weak var cancelButton: MainButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CREATE_ACCOUNT_VIEW_TITLE
        cancelButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        alertMessageLabel.text = ""
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let username = usernameTextField.text, !username.isEmpty else {
                alertMessageLabel.text = "Please fill in all fields."
                return
        }
        DataService.shared.createUser(email: email, password: password, username: username) { success, errorDesc in
            if success {
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                self.alertMessageLabel.text = errorDesc
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
