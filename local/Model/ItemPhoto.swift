//
//  ItemPhoto.swift
//  local
//
//  Created by Nozomi Okada on 12/25/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import Firebase

class ItemPhoto {
    
    public private(set) var path: String
    public private(set) var image: UIImage?
    
    init(path: String) {
        self.path = path
    }
    
    func download(completion: @escaping (UIImage?) -> ()) {
        if image != nil { completion(image); return }
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(path)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard let data = data else {
                return
            }
            self.image = UIImage(data: data)
            completion(self.image)
        }
    }
}
