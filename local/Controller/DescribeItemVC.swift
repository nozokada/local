//
//  DescribeItemVC.swift
//  local
//
//  Created by Nozomi Okada on 12/19/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class DescribeItemVC: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var nextButton: MainButton!
    
    var itemImage: UIImage!
    var itemTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableNextButton()
        addTapToView()
    }
    
    func initData(image: UIImage, title: String) {
        itemTitle = title
        itemImage = image
    }
    
    func addTapToView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(sender:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func priceLabelEditingDidEnd(_ sender: Any) {
        if priceLabel.text != nil {
            enableNextButton()
        }
        else {
            disableNextButton()
        }
    }
    
    func enableNextButton() {
        nextButton.alpha = 1.0
        nextButton.isEnabled = true
    }
    
    func disableNextButton() {
        nextButton.alpha = 0.5
        nextButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reviewPostVC = segue.destination as? ReviewPostVC {
            let itemPrice = priceLabel.text!
            reviewPostVC.initData(image: itemImage,
                                  title: itemTitle,
                                  description: descriptionTextView.text,
                                  price: itemPrice)
        }
    }
}
