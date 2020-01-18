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
    
    func uploadOffer(id: String, userId: String) {
        let offer = Offer(id: id, itemId: item.id, to: item.createdBy, from: userId)
        DataService.shared.uploadOffer(offer: offer, item: item) { success in
            if success {
                self.openMessageVC(offer: offer, item: self.item)
            } else {
                debugPrint("Failed to upload offer (display alert)")
            }
        }
    }
    
    func openMessageVC(offer: Offer, item: Item) {
        if let messageVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC {
            messageVC.initData(offer: offer, item: self.item, receipient: offer.to)
            self.present(messageVC, animated: true, completion: nil)
        }
        self.enableAskButton()
    }
    
    @IBAction func askButtonTapped(_ sender: Any) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        if item.createdBy == userId {
            debugPrint("You can't make an offer for your item (display alert)")
            return
        }
        disableAskButton()
        DataService.shared.getOffers(type: FROM) { offers in
            for offer in offers {
                if offer.itemId == self.item.id {
                    self.openMessageVC(offer: offer, item: self.item)
                    return
                }
            }
            let id = UUID().uuidString
            self.uploadOffer(id: id, userId: userId)
        }
    }
}
