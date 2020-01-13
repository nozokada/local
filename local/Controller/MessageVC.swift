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
    @IBOutlet weak var messageTextField: UITextField!
    
    var loadingSpinner: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    let screenSize = UIScreen.main.bounds
    
    var offer: Offer!
    var item: Item!
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messageTextField.delegate = self
        
        configureRefreshControl()
        addLoadingSpinner()
        loadHeaderView()
        fetchMessages()
    }
    
    func initData(offer: Offer, item: Item) {
        self.offer = offer
        self.item = item
    }
    
    func loadHeaderView() {
        itemImageView.layer.cornerRadius = 5
        item.photo.download() { (image) in
            self.itemImageView.image = image
        }
        itemTitleLabel.text = item.title
    }
    
    func addLoadingSpinner() {
        loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.center = CGPoint(x: screenSize.width / 2 - (loadingSpinner?.frame.width)! / 2,
                                         y: messagesTableView.frame.height / 2 - (loadingSpinner?.frame.width)! / 2)
        loadingSpinner.style = .large
        loadingSpinner.color = MAIN_COLOR
        loadingSpinner.startAnimating()
        messagesTableView.addSubview(loadingSpinner)
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
        DataService.shared.getMessages(offer: offer){ (messages) in
            self.messages = messages
            self.messagesTableView.reloadData()
            self.removeLoadingSpinner()
            self.refreshControl.endRefreshing()
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
        let messageContent = messages[indexPath.row].content
        cell.contentLabel.text = messageContent
        return cell
    }
}

extension MessageVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if messageTextField.text == "" { return false }
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        let id = UUID().uuidString
        let message = Message(id: id, offerId: offer.id, content: messageTextField.text!, to: item.createdBy, from: userId)
        DataService.shared.uploadMessage(message: message) { success in
            if success {
                self.messageTextField.text = ""
                self.fetchMessages()
            }
        }
        return false
     }
}
