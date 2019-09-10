//
//  SpecificShowViewController.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class SpecificShowViewController: UIViewController {
    //MARK: -- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -- Properties
    var episodes = [showEpisode]() {
        didSet {
            tableView.reloadData()
        }
    }
    var currentShowURL = String()
    var currentShowName = String()
    
    //MARK: -- Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else {fatalError("No identifier in segue")}
        
        switch segueIdentifer {
        case "segueToDetail":
            guard let destVC = segue.destination as? detailViewController else { fatalError("Unexpected segue VC") }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("No row selected") }
            let selectedEpisode = episodes[selectedIndexPath.row]
            destVC.currentEpisode = selectedEpisode
        default:
            fatalError("unexpected segue identifier")
        }
    }
    
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
        self.navigationItem.title = currentShowName
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
        if let currentImage = currentEpisode.image?.original {
            ImageHelper.shared.fetchImage(urlString: currentImage) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let imageFromOnline):
                        episodeCell.episodeImage.image = imageFromOnline
                    }
                }
            }
        } else { episodeCell.episodeImage.image = UIImage(named: "noImage") }
        return episodeCell
    }
}

//MARK: -- Delegate Methods

extension SpecificShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}



