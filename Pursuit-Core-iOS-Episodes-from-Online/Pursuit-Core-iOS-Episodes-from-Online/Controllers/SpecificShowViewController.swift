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
    
    var holdThisShit = [Int]()

    
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
    
    private func setCellDesign(cell: showEpisodesTableViewCell){
        cell.backgroundColor = .clear
        cell.episodeNameLabel.textColor = .white
        cell.seasonEpisodeLabel.textColor = .white
        let clearBG = UIView()
        clearBG.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = clearBG
    }
    
    private func setCellImage(ep: showEpisode, cell: showEpisodesTableViewCell) {
        if let currentImage = ep.image?.original {
            ImageHelper.shared.fetchImage(urlString: currentImage) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let imageFromOnline):
                        cell.episodeImage.image = imageFromOnline
                    }
                }
            }
        } else {
            cell.episodeImage.image = UIImage(named: "noImage")
        }
    }
    
    private func setCellText(ep: showEpisode, cell: showEpisodesTableViewCell) {
        cell.episodeNameLabel.text = ep.name
        cell.seasonEpisodeLabel.text = "S\(ep.season) E\(ep.number)"
        cell.runTimeLabel.text = "\(ep.runtime) min"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getSelectedShowData(newshowURL: currentShowURL)
        print(holdThisShit)
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
    
        setCellDesign(cell: episodeCell)
        setCellText(ep: currentEpisode, cell: episodeCell)
        setCellImage(ep: currentEpisode, cell: episodeCell)
        return episodeCell
    }
}

//MARK: -- Delegate Methods

extension SpecificShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}



// IDEAS:
//Get last cell's season label text and convert that a string
//Iterate through each of the episodes in the episode array, append the episode.season number to an array of Ints and then either:
// - Convert it into a set and then back into array, followed by reordering it.
// -Get the .max() result

