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
    
    private(set) public var items = [Item]()
    
    let cellHorizontalPaddingSize: CGFloat = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        
        items = DataService.shared.getItems()
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
        cell.updateViews(item: item)
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
