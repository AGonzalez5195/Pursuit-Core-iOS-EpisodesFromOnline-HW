//
//  ShowTableViewCell.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var showRatingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)  
    }

}
