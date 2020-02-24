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
    
    func uploadItemImage(itemImageRef: StorageReference) {
        DataService.shared.uploadItemImage(image: itemImage, storageRef: itemImageRef) { success, error in
            if let error = error {
                debugPrint("Error uploading item image: \(error.localizedDescription)")
                self.postButton.enable()
            } else {
                self.dismiss(animated: true, completion: nil)
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
        
        DataService.shared.uploadItem(item: item) { success, error in
            if let error = error {
                debugPrint("Error uploading item \(error.localizedDescription)")
                self.postButton.enable()
            } else {
                self.uploadItemImage(itemImageRef: itemImageRef)
            }
        }
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        let id = UUID().uuidString
        uploadItem(id: id)
        postButton.disable()
    }
}
