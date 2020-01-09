//
//  DataService.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let shared = DataService()

    func getItems(completion: @escaping (([Item]) -> ())) {
        var items = [Item]()
        debugPrint("Fetching items")
        Firestore.firestore().collection(ITEMS_REF).getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                debugPrint("Failed to download items")
                completion([])
                return
            }
            for document in documents {
                let itemData = document.data()
                items.append(
                    Item(id: document.documentID,
                         title: itemData[TITLE] as! String,
                         price: itemData[PRICE] as! String,
                         description: itemData[DESCRIPTION] as! String,
                         imagePaths: itemData[IMAGE_PATHS] as! [String]
                    )
                )
            }
            completion(items)
        }
    }
    
    func getItem(id: String, completion: @escaping ((Item?) -> ())) {
        Firestore.firestore().collection(ITEMS_REF).document(id).getDocument { (document, err) in
            guard let document = document, document.exists else {
                debugPrint("Document does not exist")
                completion(nil)
                return
            }
            let itemData = document.data()
            let item = Item(id: document.documentID,
                            title: itemData![TITLE] as! String,
                            price: itemData![PRICE] as! String,
                            description: itemData![DESCRIPTION] as! String,
                            imagePaths: itemData![IMAGE_PATHS] as! [String]
            )
            completion(item)
        }
    }
    
    func getOffers(senderId: String, completion: @escaping (([Offer]) -> ())) {
        var offers = [Offer]()
        Firestore.firestore().collection(OFFERS_REF).whereField(SENDER_ID, isEqualTo: senderId).getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                debugPrint("Failed to download offers")
                completion([])
                return
            }
            for document in documents {
                let offerData = document.data()
                offers.append(
                    Offer(id: document.documentID,
                          itemId: offerData[ITEM_ID] as! String,
                          senderId: offerData[SENDER_ID] as! String
                    )
                )
            }
            completion(offers)
        }
    }
}
