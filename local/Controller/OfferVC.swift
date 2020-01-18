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
    
    let screenSize = UIScreen.main.bounds
    
    var offers = [Offer]()
    var items = [String: Item]()
    var buyingSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersTableView.dataSource = self
        offersTableView.delegate = self
        
        configureRefreshControl()
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
        offers.removeAll()
        addLoadingSpinner()
        fetchOffers()
    }
    
    func fetchOffers() {
        let offerType = buyingSelected ? FROM : TO
        DataService.shared.getOffers(type: offerType) { (offers) in
            if offers.count == 0 {
                self.reloadTable()
                return
            }
            self.offers = offers
            self.fetchItemsForOffers()
        }
    }
    
    func fetchItemsForOffers() {
        var processedOfferCount = 0
        for offer in offers {
            DataService.shared.getItem(id: offer.itemId) { item in
                if let item = item {
                    self.items[item.id] = item
                }
                processedOfferCount += 1
                if processedOfferCount == self.offers.count {
                    self.reloadTable()
                }
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
        guard let item = items[offer.itemId] else { return OfferCell() }
        cell.update(item: item)
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
