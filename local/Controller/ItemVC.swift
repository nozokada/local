//
//  ItemVC.swift
//  local
//
//  Created by Nozomi Okada on 12/15/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import Firebase

class ItemVC: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: ItemPriceLabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var askButton: MainButton!
    
    var itemId: String!
    var itemPhoto: ItemPhoto!
    var itemTitle: String!
    var itemPrice: String = ""
    var itemDescription: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemPhoto.download() { (image) in
            self.itemImageView.image = image
        }
        itemTitleLabel.text = itemTitle
        itemPriceLabel.text = " \(CURRENCY_SYMBOL)\(itemPrice) "
        itemDescriptionLabel.text = itemDescription
        
        itemPriceLabel.layer.cornerRadius = 5
        itemPriceLabel.clipsToBounds = true
    }
    
    func initItem(item: Item) {
        itemId = item.id
        itemPhoto = item.photo
        itemTitle = item.title
        itemPrice = item.price
        itemDescription = item.description
    }
    
    func enableAskButton() {
        askButton.alpha = 1.0
        askButton.isEnabled = true
    }
    
    func disableAskButton() {
        askButton.alpha = 0.5
        askButton.isEnabled = false
    }
    
    @IBAction func askButtonTapped(_ sender: Any) {
        disableAskButton()
        let id = UUID().uuidString
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(OFFERS_REF).document(id).setData([
            ITEM_ID: itemId!,
            SENDER_ID: userId,
            CREATED_TIMESTAMP: FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("Offer was successfully created")
                self.enableAskButton()
                if let messageVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC {
                    self.present(messageVC, animated: true, completion: nil)
                }
            }
        }
    }
}
