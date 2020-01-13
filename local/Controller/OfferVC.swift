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

    @IBOutlet weak var offersTableView: UITableView!
    
    var loadingSpinner: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    let screenSize = UIScreen.main.bounds
    
    var offers = [Offer]()
    var items = [String: Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersTableView.dataSource = self
        offersTableView.delegate = self
        
        configureRefreshControl()
        addLoadingSpinner()
        fetchOffers()
    }
    
    func addLoadingSpinner() {
        loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.center = CGPoint(x: screenSize.width / 2 - (loadingSpinner?.frame.width)! / 2,
                                         y: offersTableView.frame.height / 2 - (loadingSpinner?.frame.width)! / 2)
        loadingSpinner.style = .large
        loadingSpinner.color = MAIN_COLOR
        loadingSpinner.startAnimating()
        offersTableView.addSubview(loadingSpinner)
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
    
    func fetchOffers() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        DataService.shared.getOutGoingOffers(from: userId) { (offers) in
            self.offers = offers
            for offer in offers {
                DataService.shared.getItem(id: offer.itemId) { item in
                    if let item = item {
                        self.items[item.id] = item
                    }
                    if self.items.count == self.offers.count {
                        self.offersTableView.reloadData()
                        self.removeLoadingSpinner()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
    
    @objc func refreshOffers() {
        fetchOffers()
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
        guard let item = items[offer.itemId] else { return OfferCell() }
        cell.update(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        guard let item = items[offer.itemId] else { return }
        if let messageVC = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC {
            messageVC.initData(offer: offer, item: item)
            present(messageVC, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
