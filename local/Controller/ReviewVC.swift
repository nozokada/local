//
//  ReviewVC.swift
//  local
//
//  Created by Nozomi Okada on 12/20/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import Firebase

class ReviewVC: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: ItemPriceLabel!
    @IBOutlet weak var postButton: MainButton!
    
    var itemImage: UIImage!
    var itemTitle: String = ""
    var itemDescription: String = ""
    var itemPrice: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedImageView.image = itemImage
        titleLabel.text = itemTitle
        descriptionLabel.text = itemDescription
        priceLabel.text = " \(CURRENCY_SYMBOL)\(itemPrice) "
    }
    
    func initData(image: UIImage, title: String, description: String, price: String) {
        itemImage = image
        itemTitle = title
        itemDescription = description
        itemPrice = price
    }
    
    func enablePostButton() {
        postButton.alpha = 1.0
        postButton.isEnabled = true
    }
    
    func disablePostButton() {
        postButton.alpha = 0.5
        postButton.isEnabled = false
    }
    
    func uploadItemImage(itemImageRef: StorageReference) {
        DataService.shared.uploadItemImage(image: itemImage, storageRef: itemImageRef) { success in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                debugPrint("Failed to upload item image (display alert)")
                self.enablePostButton()
            }
        }
    }
    
    func uploadItem(id: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child(IMAGES_REF)
        let itemImageRef = imagesRef.child(UUID().uuidString)
        let imagePath = itemImageRef.fullPath
        
        let item = Item(id: id, title: itemTitle, price: itemPrice, description: itemDescription, createdBy: userId, imagePaths: [imagePath])
        
        DataService.shared.uploadItem(item: item) { success in
            if success {
                self.uploadItemImage(itemImageRef: itemImageRef)
            } else {
                debugPrint("Failed to upload item (display alert)")
                self.enablePostButton()
            }
        }
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        let id = UUID().uuidString
        uploadItem(id: id)
        disablePostButton()
    }
}
