//
//  BrowseVC.swift
//  local
//
//  Created by Nozomi Okada on 12/12/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class BrowseVC: UIViewController {
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var loadingSpinner: UIActivityIndicatorView?
    
    let screenSize = UIScreen.main.bounds
    let cellHorizontalPaddingSize: CGFloat = 6
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        
        addLoadingSpinner()
        DataService.shared.getItems() { (items) in
            self.items = items
            self.itemsCollectionView.reloadData()
            self.removeLoadingSpinner()
        }
    }
    
    func addLoadingSpinner() {
        loadingSpinner = UIActivityIndicatorView()
        loadingSpinner?.center = CGPoint(x: screenSize.width / 2 - (loadingSpinner?.frame.width)! / 2,
                                         y: itemsCollectionView.frame.height / 2 - (loadingSpinner?.frame.width)! / 2)
        loadingSpinner?.style = .large
        loadingSpinner?.color = MAIN_COLOR
        loadingSpinner?.startAnimating()
        itemsCollectionView.addSubview(loadingSpinner!)
    }
    
    func removeLoadingSpinner() {
        if loadingSpinner != nil {
            loadingSpinner?.removeFromSuperview()
        }
    }
}

extension BrowseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
            as? ItemCell else { return ItemCell() }
        let item = items[indexPath.row]
        cell.update(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else { return }
        let item = items[indexPath.row]
        if let itemVC = storyboard?.instantiateViewController(withIdentifier: "ItemVC") as? ItemVC {
            itemVC.initItem(item: item)
            present(itemVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2 - cellHorizontalPaddingSize * 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellHorizontalPaddingSize, bottom: 0, right: cellHorizontalPaddingSize)
    }
}
