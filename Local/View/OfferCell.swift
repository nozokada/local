//
//  OfferCell.swift
//  local
//
//  Created by Nozomi Okada on 1/7/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit
import FirebaseUI

class OfferCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var imageDownloadTask: StorageDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemTitleLabel.text = ""
        usernameLabel.text = ""
        imageDownloadTask?.cancel()
        itemImageView.image = LOADING_IMAGE
    }
    
    func customizeView() {
        itemImageView.layer.cornerRadius = 5
    }
    
    func updateItemData(item: Item) {
        itemTitleLabel.text = item.title
        imageDownloadTask = item.photo.download() { (image) in
            self.itemImageView.image = image
        }
    }
}
