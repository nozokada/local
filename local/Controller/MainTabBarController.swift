//
//  MainTabBarController.swift
//  local
//
//  Created by Nozomi Okada on 12/25/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let identifier = viewController.restorationIdentifier, identifier == "PostNC" {
            let postNC = storyboard?.instantiateViewController(withIdentifier: "PostNC") as! UINavigationController
            postNC.modalPresentationStyle = .fullScreen
            present(postNC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
