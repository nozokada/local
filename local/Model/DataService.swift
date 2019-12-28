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
//    private var items = [
//        Item(title: "Kaytee Silent Spinner 10-inch Exercise Wheel", price: "5", imageURL: "hamster_wheel.jpg", description: ""),
//        Item(title: "Splatoon 2 for Nintendo Switch", price: "35", imageURL: "splatoon_2.jpg", description: "I just bought it last month and but no longer needed. Working perfectly. Like new condition."),
//        Item(title: "Wahl Color Pro Complete Hair Cutting Kit", price: "10", imageURL: "clipper.jpg", description: ""),
//        Item(title: "Remington All-in-1 Lithium Powered Grooming Kit", price: "15", imageURL: "grooming_kit.jpg", description: ""),
//        Item(title: "Toyota 90915-YZZF2 Oil Filters (Set of 2)", price: "5", imageURL: "oil_filter.jpg", description: ""),
//    ]
//
    func getItems(completion: @escaping (([Item]) -> ())) {
        var items = [Item]()
        Firestore.firestore().collection(ITEMS_REF).getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("Failed to download items")
                completion([])
                return
            }
            for document in documents {
                print("\(document.documentID) => \(document.data())")
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
