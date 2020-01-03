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
//                debugPrint("\(document.documentID) => \(document.data())")
                let itemData = document.data()
                items.append(
                    Item(
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
}
