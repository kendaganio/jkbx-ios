//
//  Track.swift
//  jkbx-ios
//
//  Created by Ken-Lauren Daganio on 7/13/15.
//  Copyright (c) 2015 Ken-Lauren Daganio. All rights reserved.
//

import Foundation
import UIKit

struct Track {
    var id: String
    var title: String
    var addedBy: String
    var thumbnail: String
    
    func props() -> String {
        return "\(self.id), \(self.title), \(self.addedBy), \(self.thumbnail)"
    }
}