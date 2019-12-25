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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createAccountButton: MainButton!
    @IBOutlet weak var cancelButton: MainButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CREATE_ACCOUNT_VIEW_TITLE
        cancelButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                debugPrint("Error creating user: \(error!.localizedDescription)")
                return
            }
            let changeProfileRequest = user.createProfileChangeRequest()
            changeProfileRequest.displayName = username
            changeProfileRequest.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            })

            Firestore.firestore().collection(USERS_REF).document(user.uid).setData([
                USERNAME : username,
                CREATED_TIMESTAMP : FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    debugPrint("Account was successfully created")
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
