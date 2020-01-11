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
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        item.photo.download() { (image) in
            self.itemImageView.image = image
        }
        itemTitleLabel.text = item.title
        itemPriceLabel.text = " \(CURRENCY_SYMBOL)\(item.price) "
        itemDescriptionLabel.text = item.description
        
        itemPriceLabel.layer.cornerRadius = 5
        itemPriceLabel.clipsToBounds = true
    }
    
    func initItem(item: Item) {
        self.item = item
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
            ITEM_ID: item.id,
            FROM: userId,
            TO: item.createdBy,
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
