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
    
    func uploadItemImage(id: String) {
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child(IMAGES_REF)
        let filePath = "\(id)"
        let itemImageRef = imagesRef.child(filePath)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let data = itemImage.jpegData(compressionQuality: 1)!
        itemImageRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let _ = metadata, error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            itemImageRef.downloadURL { (url, error) in
                guard let downloadURL = url, error == nil else {
                    debugPrint(error!.localizedDescription)
                    return
                }
                self.uploadItem(imageURL: downloadURL.absoluteString)
            }
        }
    }
    
    func uploadItem(imageURL: String) {
        
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        let id = UUID().uuidString
        uploadItemImage(id: id)
    }
}
