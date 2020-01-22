//
//  MessageVC.swift
//  local
//
//  Created by Nozomi Okada on 1/8/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit
import Firebase

class MessageVC: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: MainTextField!
    
    var loadingSpinner: MainIndicatorView!
    var refreshControl: UIRefreshControl!
    
    let userId = Auth.auth().currentUser!.uid
    
    var offer: Offer!
    var item: Item!
    var receipient: String!
    var messages = [Message]()
    var newlyCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        messageTextField.delegate = self
        
        configureRefreshControl()
        addLoadingSpinner()
        loadHeaderView()
        fetchMessages()
    }
    
    func initData(offer: Offer, item: Item, receipient: String) {
        self.offer = offer
        self.item = item
        self.receipient = receipient
    }
    
    func loadHeaderView() {
        itemImageView.layer.cornerRadius = 5
        item.photo.download() { (image) in
            self.itemImageView.image = image
        }
        itemTitleLabel.text = item.title
    }
    
    func addLoadingSpinner() {
        loadingSpinner = MainIndicatorView(parentView: messagesTableView)
        loadingSpinner.startAnimating()
    }
    
    func removeLoadingSpinner() {
        if loadingSpinner != nil {
            loadingSpinner.removeFromSuperview()
        }
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = MAIN_COLOR
        refreshControl.addTarget(self, action: #selector(refreshMessages), for: .valueChanged)
        messagesTableView.refreshControl = refreshControl
        messagesTableView.alwaysBounceVertical = true
    }
    
    func fetchMessages() {
        DataService.shared.getMessages(offer: offer) { messages, error in
            self.newlyCreated = messages.count == 0 && error == nil
            self.messages = messages
            self.messagesTableView.reloadData()
            self.removeLoadingSpinner()
            self.refreshControl.endRefreshing()
        }
    }
    
    func uploadMessage(id: String) {
        guard let messageContent = messageTextField.text else { return }
        let message = Message(id: id, offerId: offer.id, content: messageContent, to: receipient, from: userId)
        self.messageTextField.text = ""
        DataService.shared.uploadMessage(message: message) { success, error in
            if let _ = error {
                self.messageTextField.text = messageContent
            }
        }
    }
    
    @objc func refreshMessages() {
        fetchMessages()
    }
}

extension MessageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
            as? MessageCell else { return MessageCell() }
        cell.update(message: messages[indexPath.row], userId: userId)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}

extension MessageVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if messageTextField.text == "" { return true }
        let id = UUID().uuidString
        if newlyCreated {
            DataService.shared.uploadOffer(offer: offer, item: item) { success, error in
                if let _ = error { return }
                self.uploadMessage(id: id)
            }
        } else {
            uploadMessage(id: id)
        }
        return true
     }
}
