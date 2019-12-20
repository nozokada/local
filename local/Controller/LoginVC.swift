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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapToView()
    }
    
    func addTapToView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(sender:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (AuthResult, error) in
            if let error = error {
                debugPrint("Error logging in: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
