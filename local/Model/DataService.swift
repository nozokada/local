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
    
    func createUser(email: String, password: String, username: String, completion: @escaping (Bool, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user else {
                debugPrint("Failed to create authentication")
                completion(false, error)
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
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }

    func getItems(completion: @escaping (([Item], Error?) -> ())) {
        var items = [Item]()
        Firestore.firestore().collection(ITEMS_REF).order(by: CREATED_TIMESTAMP, descending: true).getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                debugPrint("Failed to download items")
                completion([], error)
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
            completion(items, nil)
        }
    }
    
    func getItem(id: String, completion: @escaping ((Item?, Error?) -> ())) {
        Firestore.firestore().collection(ITEMS_REF).document(id).getDocument { document, error in
            guard let document = document, document.exists else {
                debugPrint("Failed to download item")
                completion(nil, error)
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
            completion(item, nil)
        }
    }
    
    func uploadItem(item: Item, completion: @escaping (Bool, Error?) -> ()) {
        Firestore.firestore().collection(ITEMS_REF).document(item.id).setData([
            TITLE: item.title,
            DESCRIPTION: item.description,
            PRICE: item.price,
            IMAGE_PATHS: item.imagePaths,
            CREATED_BY : item.createdBy,
            CREATED_TIMESTAMP : FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint("Failed to upload item")
                completion(false, error)
            } else {
                debugPrint("Successfully uploaded item")
                completion(true, nil)
            }
        }
    }
    
    func uploadItemImage(image: UIImage, storageRef: StorageReference, completion: @escaping (Bool, Error?) -> ()) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let data = image.jpegData(compressionQuality: IMAGE_COMPRESSION_RATE)!
        storageRef.putData(data, metadata: metadata) { metadata, error in
             if let error = error {
                debugPrint("Failed to upload image")
                completion(false, error)
            } else {
                debugPrint("Successfully uploaded item image")
                completion(true, nil)
            }
        }
    }
    
    func getOffers(type: String, userId: String, completion: @escaping (([Offer], Error?) -> ())) {
        var offers = [Offer]()
        Firestore.firestore().collection(OFFERS_REF).whereField(type, isEqualTo: userId).order(by: CREATED_TIMESTAMP, descending: true).getDocuments() { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                debugPrint("Failed to download offers")
                completion([], error)
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
            completion(offers, nil)
        }
    }
    
    func uploadOffer(offer: Offer, item: Item, completion: @escaping (Bool, Error?) -> ()) {
        Firestore.firestore().collection(OFFERS_REF).document(offer.id).setData([
            ITEM_ID: offer.itemId,
            TO: item.createdBy,
            FROM: offer.from,
            CREATED_TIMESTAMP: FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint("Failed to upload offer")
                completion(false, error)
            } else {
                debugPrint("Successfully uploaded offer")
                completion(true, nil)
            }
        }
    }
    
    func getMessages(offer: Offer, completion: @escaping ([Message], Error?) ->()) {
        Firestore.firestore().collection(MESSAGES_REF).whereField(OFFER_ID, isEqualTo: offer.id).order(by: CREATED_TIMESTAMP, descending: true).addSnapshotListener() { querySnapshot, error in
            var messages = [Message]()
            guard let documents = querySnapshot?.documents else {
                debugPrint("Failed to download messages")
                completion([], error)
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
            completion(messages, nil)
        }
    }
    
    func uploadMessage(message: Message, completion: @escaping (Bool, Error?) -> ()) {
        Firestore.firestore().collection(MESSAGES_REF).document(message.id).setData([
            OFFER_ID: message.offerId,
            CONTENT: message.content,
            TO: message.to,
            FROM: message.from,
            CREATED_TIMESTAMP: FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                debugPrint("Failed to upload message")
                completion(false, error)
            } else {
                debugPrint("Successfully uploaded message")
                completion(true, nil)
            }
        }
    }
}
