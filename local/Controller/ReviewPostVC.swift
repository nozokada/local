//
//  ReviewPostVC.swift
//  local
//
//  Created by Nozomi Okada on 12/20/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import Firebase

class ReviewPostVC: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
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
        priceLabel.layer.cornerRadius = 5
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
    
    func uploadItemImage(id: String) {
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child(IMAGES_REF)
        let itemImageRef = imagesRef.child(UUID().uuidString)
        let imagePath = itemImageRef.fullPath
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let data = itemImage.jpegData(compressionQuality: IMAGE_COMPRESSION_RATE)!
        itemImageRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let _ = metadata, error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            self.uploadItem(id: id, imagePaths: [imagePath])
        }
    }
    
    func uploadItem(id: String, imagePaths: [String]) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(ITEMS_REF).document(id).setData([
            TITLE: itemTitle,
            DESCRIPTION: itemDescription,
            PRICE: itemPrice,
            IMAGE_PATHS: imagePaths,
            CREATED_BY : userId,
            CREATED_TIMESTAMP : FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("Item was successfully uploaded")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        let id = UUID().uuidString
        uploadItemImage(id: id)
        disablePostButton()
    }
}
