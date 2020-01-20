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
    
    func createUser(email: String, password: String, username: String, completion: @escaping (Bool, String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                debugPrint("Failed to create authentication")
                completion(false, error?.localizedDescription)
                return
            }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges() { error in
                if let _ = error {
                    debugPrint("Failed to change user display name")
                }
            }
            Firestore.firestore().collection(USERS_REF).document(user.uid).setData([
                USERNAME : username,
                CREATED_TIMESTAMP : FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    debugPrint("Failed to create user")
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    }

    func getItems(completion: @escaping (([Item]) -> ())) {
        var items = [Item]()
        Firestore.firestore().collection(ITEMS_REF).order(by: CREATED_TIMESTAMP, descending: true).getDocuments() { (querySnapshot, error) in
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
        Firestore.firestore().collection(ITEMS_REF).document(id).getDocument { (document, error) in
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
    
    func getOffers(type: String, completion: @escaping (([Offer]) -> ())) {
        var offers = [Offer]()
        guard let userId = Auth.auth().currentUser?.uid else { completion([]); return }
        Firestore.firestore().collection(OFFERS_REF).whereField(type, isEqualTo: userId).order(by: CREATED_TIMESTAMP, descending: true).getDocuments() { (querySnapshot, error) in
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
            debugPrint("Successfully downloaded offers")
            completion(offers)
        }
    }
    
    func uploadOffer(offer: Offer, item: Item, completion: @escaping (Bool) -> ()) {
        Firestore.firestore().collection(OFFERS_REF).document(offer.id).setData([
            ITEM_ID: offer.itemId,
            TO: item.createdBy,
            FROM: offer.from,
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
    
    func getMessages(offer: Offer, completion: @escaping ([Message]) ->()) {
        Firestore.firestore().collection(MESSAGES_REF).whereField(OFFER_ID, isEqualTo: offer.id).order(by: CREATED_TIMESTAMP, descending: true).addSnapshotListener() { (querySnapshot, error) in
            var messages = [Message]()
            guard let documents = querySnapshot?.documents else {
                debugPrint("Failed to download messages")
                completion([])
                return
            }
            for document in documents {
                let messageData = document.data()
                messages.append(
                    Message(id: document.documentID,
                            offerId: messageData[OFFER_ID] as! String,
                            content: messageData[CONTENT] as! String,
                            to: messageData[TO] as! String,
                            from: messageData[FROM] as! String
                    )
                )
            }
            debugPrint("Successfully downloaded messages")
            completion(messages)
        }
    }
    
    func uploadMessage(message: Message, completion: @escaping (Bool) -> ()) {
        Firestore.firestore().collection(MESSAGES_REF).document(message.id).setData([
            OFFER_ID: message.offerId,
            CONTENT: message.content,
            TO: message.to,
            FROM: message.from,
            CREATED_TIMESTAMP: FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(false)
            } else {
                debugPrint("Successfully uploaded message")
                completion(true)
            }
        }
    }
}
