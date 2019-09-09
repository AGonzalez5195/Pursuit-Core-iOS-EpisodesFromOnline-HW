//
//  SpecificShowTableViewCell.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class SpecificShowTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeImage: UIImageView!
    
    @IBOutlet weak var episodeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
