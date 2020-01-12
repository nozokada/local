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
                         createdBy: itemData[CREATED_BY] as! String,
                         imagePaths: itemData[IMAGE_PATHS] as! [String]
                    )
                )
            }
            debugPrint("Successfully downloaded items")
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
                            createdBy: itemData![CREATED_BY] as! String,
                            imagePaths: itemData![IMAGE_PATHS] as! [String]
            )
            debugPrint("Successfully downloaded item")
            completion(item)
        }
    }
    
    func uploadItem(item: Item, completion: @escaping (Bool) -> ()) {
        Firestore.firestore().collection(ITEMS_REF).document(item.id).setData([
            TITLE: item.title,
            DESCRIPTION: item.description,
            PRICE: item.price,
            IMAGE_PATHS: item.imagePaths,
            CREATED_BY : item.createdBy,
            CREATED_TIMESTAMP : FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(false)
            } else {
                debugPrint("Successfully uploaded item")
                completion(true)
            }
        }
    }
    
    func uploadItemImage(image: UIImage, storageRef: StorageReference, completion: @escaping (Bool) -> ()) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let data = image.jpegData(compressionQuality: IMAGE_COMPRESSION_RATE)!
        storageRef.putData(data, metadata: metadata) { (metadata, error) in
             if let error = error {
                debugPrint(error.localizedDescription)
                completion(false)
            } else {
                debugPrint("Successfully uploaded item image")
                completion(true)
            }
        }
    }
    
    func getOutGoingOffers(from: String, completion: @escaping (([Offer]) -> ())) {
        var offers = [Offer]()
        Firestore.firestore().collection(OFFERS_REF).whereField(FROM, isEqualTo: from).getDocuments() { (querySnapshot, err) in
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
                          to: offerData[TO] as! String,
                          from: offerData[FROM] as! String
                    )
                )
            }
            completion(offers)
        }
    }
    
    func uploadOffer(offer: Offer, item: Item, completion: @escaping (Bool) -> ()) {
        Firestore.firestore().collection(OFFERS_REF).document(offer.id).setData([
            ITEM_ID: offer.itemId,
            FROM: offer.from,
            TO: item.createdBy,
            CREATED_TIMESTAMP: FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(false)
            } else {
                debugPrint("Successfully uploaded offer")
                completion(true)
            }
        }
    }
}
