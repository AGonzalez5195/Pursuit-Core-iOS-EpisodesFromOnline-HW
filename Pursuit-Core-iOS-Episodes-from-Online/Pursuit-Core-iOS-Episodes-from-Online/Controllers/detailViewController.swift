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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: -- Properties
    var currentEpisode: showEpisode!
    
    //MARK: -- Functions
    private func loadCurrentEpisodeImage() {
        spinner.sizeToFit()
        spinner.isHidden = false
        spinner.startAnimating()
        
        if let currentImage = currentEpisode.image?.original {
            ImageHelper.shared.fetchImage(urlString: currentImage) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let imageFromOnline):
                        self.episodeImage.image = imageFromOnline
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        
                    }
                }
            }
        } else { episodeImage.image = #imageLiteral(resourceName: "noImage")
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
        }
    }
    
    private func setLabelColors(){
        [episodeNameLabel, seasonEpisodeLabel, airDateLabel].forEach{$0?.textColor = .white}
        descriptionText.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        descriptionText.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    private func setLabelText() {
        episodeNameLabel.text = currentEpisode.name
        seasonEpisodeLabel.text = "Season: \(currentEpisode.season) Episode: \(currentEpisode.number)"
        if let currentEpRuntime = currentEpisode.runtime {
            runTimeLabel.text = "\(currentEpRuntime) min"
        } else {
            runTimeLabel.text = ""
        }
        
        var episodeAirdate = currentEpisode.airdate
        episodeAirdate = Date.changeDateFormat(dateString: episodeAirdate, fromFormat: "yyyy-MM-dd", toFormat: "MM/dd/yyyy")
        airDateLabel.text = episodeAirdate
        
        if let string = currentEpisode.summary {
            let summaryWithNoHTMLStuff = string.replacingOccurrences(of: "(?i)<p[^>]*>", with: "", options: .regularExpression, range: nil)
            let cleanedUpSummary = summaryWithNoHTMLStuff.replacingOccurrences(of: "</p>", with: " ")
            descriptionText.text = cleanedUpSummary
        } else {
            descriptionText.text = "No summary available"
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
