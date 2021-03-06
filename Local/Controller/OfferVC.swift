//
//  OfferVC.swift
//  local
//
//  Created by Nozomi Okada on 1/7/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit
import Firebase

class OfferVC: UIViewController {

    @IBOutlet weak var offerTypesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var offersTableView: UITableView!
    
    var loadingSpinner: MainIndicatorView!
    var refreshControl: UIRefreshControl!
    
    var offers = [Offer]()
    var items = [String: Item]()
    var usernames = [String: String]()
    var buyingSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersTableView.dataSource = self
        offersTableView.delegate = self
        
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLoadingSpinner()
        fetchOffers()
    }
    
    func addLoadingSpinner() {
        loadingSpinner = MainIndicatorView(parentView: offersTableView)
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
        refreshControl.addTarget(self, action: #selector(refreshOffers), for: .valueChanged)
        offersTableView.refreshControl = refreshControl
        offersTableView.alwaysBounceVertical = true
    }
    
    @IBAction func offerTypesSegmentedControlChanged(_ sender: UISegmentedControl) {
        buyingSelected = sender.selectedSegmentIndex == 0
        addLoadingSpinner()
        fetchOffers()
    }
    
    func fetchOffers() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let offerType = buyingSelected ? FROM : TO
        DataService.shared.getOffers(type: offerType, userId: userId) { offers, error in
            self.offers = offers
            self.reloadTable()
        }
    }
    
    func fetchItem(for offer: Offer, completion: @escaping (Item?) -> ()) {
        if let item = items[offer.itemId] {
            completion(item)
            return
        }
        DataService.shared.getItem(id: offer.itemId) { item, error in
            if let error = error {
                debugPrint("Error fetching item: \(error.localizedDescription)")
                completion(nil)
            } else {
                self.items[offer.itemId] = item
                completion(item)
            }
        }
    }
    
    func fetchUsername(for offer: Offer, completion: @escaping (String?) -> ()) {
        let userId = buyingSelected ? offer.to : offer.from
        if let username = usernames[userId] {
            completion(username)
            return
        }
        DataService.shared.getUsername(id: userId) { username, error in
            if let error = error {
                debugPrint("Error fetching username: \(error.localizedDescription)")
                completion(nil)
            } else {
                self.usernames[userId] = username
                completion(username)
            }
        }
    }
    
    @objc func refreshOffers() {
        fetchOffers()
    }
    
    func reloadTable() {
        self.offersTableView.reloadData()
        self.removeLoadingSpinner()
        self.refreshControl.endRefreshing()
    }
}

extension OfferVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = offersTableView.dequeueReusableCell(withIdentifier: "OfferCell", for: indexPath)
            as? OfferCell else { return OfferCell() }
        let offer = offers[indexPath.row]
        fetchItem(for: offer) { item in
            if let item = item {
                cell.updateItemData(item: item)
            }
        }
        fetchUsername(for: offer) { username in
            if let username = username {
                cell.usernameLabel.text = username
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        guard let item = items[offer.itemId] else { return }
        let receipient =  buyingSelected ? offer.to : offer.from
        if let messageVC = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC {
            messageVC.initData(offer: offer, item: item, receipient: receipient)
            present(messageVC, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
