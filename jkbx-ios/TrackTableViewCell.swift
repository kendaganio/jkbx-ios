//
//  TrackTableViewCell.swift
//  jkbx-ios
//
//  Created by Ken-Lauren Daganio on 7/17/15.
//  Copyright (c) 2015 Ken-Lauren Daganio. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
