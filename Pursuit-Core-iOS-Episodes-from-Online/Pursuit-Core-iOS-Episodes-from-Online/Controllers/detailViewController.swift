//
//  detailViewController.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    //MARK: -- Outlets
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    
    @IBOutlet weak var airDateLabel: UILabel!
    
    //MARK: -- Properties
    var currentEpisode: showEpisode!
    
    //MARK: -- Functions
    private func loadCurrentEpisodeImage() {
        if let currentImage = currentEpisode.image?.original {
            ImageHelper.shared.fetchImage(urlString: currentImage) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let imageFromOnline):
                        self.episodeImage.image = imageFromOnline
                    }
                }
            }
        } else { episodeImage.image = UIImage(named: "noImage") }
    }
    
    private func setLabelColors(){
        [episodeNameLabel, seasonEpisodeLabel, airDateLabel].forEach{$0?.textColor = .white}
        descriptionText.textColor = .white
        descriptionText.backgroundColor = .black
        view.backgroundColor = .black
    }
    private func setLabelText() {
        episodeNameLabel.text = currentEpisode.name
        seasonEpisodeLabel.text = "Season: \(currentEpisode.season) Episode: \(currentEpisode.number)"
        runTimeLabel.text = "\(currentEpisode.runtime) min"
        
        var episodeAirdate = currentEpisode.airdate
        episodeAirdate = Date.changeDateFormat(dateString: episodeAirdate, fromFormat: "yyyy-MM-dd", toFormat: "MM/dd/yyyy")
       airDateLabel.text = episodeAirdate
        
        if let string = currentEpisode.summary {
            let summaryWithNoHTMLStuff = string.replacingOccurrences(of: "(?i)<p[^>]*>", with: "", options: .regularExpression, range: nil)
            let cleanedUpSummary = summaryWithNoHTMLStuff.replacingOccurrences(of: "</p>", with: " ")
            descriptionText.text = cleanedUpSummary
        } else {
            descriptionText.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
        setLabelColors()
        loadCurrentEpisodeImage()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = episodeImage.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.9]
        episodeImage.layer.insertSublayer(gradient, at: 5)
    }
}
