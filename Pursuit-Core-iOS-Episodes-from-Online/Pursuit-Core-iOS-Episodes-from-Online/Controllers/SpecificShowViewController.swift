//
//  SpecificShowViewController.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class SpecificShowViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var episodes = [showEpisode]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var currentShowURL = String()
    
    
    
    private func getSelectedShowData(newshowURL: String){
        showEpisode.getEpisodeData(showURL: newshowURL ) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let newShowData):
                    self.episodes = newShowData
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getSelectedShowData(newshowURL: currentShowURL)
        
    }
}

//MARK: -- Datasource Methods
extension SpecificShowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentEpisode = episodes[indexPath.row]
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as! showEpisodesTableViewCell
        
        episodeCell.episodeNameLabel.text = currentEpisode.name
        episodeCell.seasonEpisodeLabel.text = "S:\(currentEpisode.season) E: \(currentEpisode.number)"
        ImageHelper.shared.fetchImage(urlString: currentEpisode.image.original) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromOnline):
                    episodeCell.episodeImage.image = imageFromOnline
                }
            }
        }
        return episodeCell
    }
}

//MARK: -- Delegate Methods

extension SpecificShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}



