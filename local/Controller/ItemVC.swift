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
    
    func initData(item: Item) {
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
        let offer = Offer(id: id, itemId: item.id, to: item.createdBy, from: userId)
        DataService.shared.uploadOffer(offer: offer, item: item) { success in
            self.enableAskButton()
            if success {
                if let messageVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC {
                    messageVC.initData(offer: offer, item: self.item)
                    self.present(messageVC, animated: true, completion: nil)
                }
            }
            else {
                debugPrint("Failed to upload offer")
            }
        }
    }
}
