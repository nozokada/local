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
        priceLabel.text = " $\(itemPrice) "
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
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let data = itemImage.jpegData(compressionQuality: IMAGE_COMPRESSION_RATE)!
        itemImageRef.putData(data, metadata: metadata) { (metadata, error) in
             if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("Item image was successfully uploaded")
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
        
        Firestore.firestore().collection(ITEMS_REF).document(id).setData([
            TITLE: itemTitle,
            DESCRIPTION: itemDescription,
            PRICE: itemPrice,
            IMAGE_PATHS: [imagePath],
            CREATED_BY : userId,
            CREATED_TIMESTAMP : FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("Item was successfully uploaded")
                self.uploadItemImage(itemImageRef: itemImageRef)
            }
        }
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        let id = UUID().uuidString
        uploadItem(id: id)
        disablePostButton()
    }
}
