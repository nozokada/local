//
//  ProfileVC.swift
//  local
//
//  Created by Nozomi Okada on 12/12/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
                loginVC.modalPresentationStyle = .fullScreen
                self.view.window?.rootViewController?.present(loginVC, animated: true, completion: nil)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

