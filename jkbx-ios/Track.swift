//
//  Track.swift
//  jkbx-ios
//
//  Created by Ken-Lauren Daganio on 7/13/15.
//  Copyright (c) 2015 Ken-Lauren Daganio. All rights reserved.
//

import Foundation
import UIKit

class Track {
    var id: String
    var title: String
    var addedBy: String
    var thumbnail: String
    
    var imgCache: UIImage?
    
    init(id: String, title: String, addedBy: String, thumbnail: String) {
        self.id = id
        self.title = title
        self.addedBy = addedBy
        self.thumbnail = thumbnail
        self.imgCache = nil
    }
    
    func props() -> String {
        return "\(self.id), \(self.title), \(self.addedBy), \(self.thumbnail)"
    }
    
    func getImage() -> UIImage? {
        if self.imgCache == nil {
            let url = NSURL(string: self.thumbnail)
            let data = NSData(contentsOfURL: url!)
            self.imgCache = UIImage(data: data!)
        }
        return self.imgCache
    }
}