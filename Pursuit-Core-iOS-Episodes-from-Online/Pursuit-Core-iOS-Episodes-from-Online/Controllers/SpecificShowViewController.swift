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
//    var showToPassToPopUp: Show!
    
    
//    MARK: --IBActions
//    @IBAction func showPopup(_ sender: UIButton) {
//      performSegue(withIdentifier: "segueToShowDetail", sender: sender)
//
//    }
    
    //MARK: -- Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else {fatalError("No identifier in segue")}
        
        switch segueIdentifer {
//        case "segueToShowDetail":
//             guard let popOverVC = segue.destination as? PopUpViewController else { fatalError("Unexpected segue VC") }
//                self.addChild(popOverVC)
//                popOverVC.view.frame = self.view.frame
//                self.view.addSubview(popOverVC.view)
//                popOverVC.didMove(toParent: self)
//                popOverVC.currentShow = showToPassToPopUp
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
        [cell.episodeNameLabel, cell.seasonEpisodeLabel].forEach{$0?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let clearBG = UIView()
            clearBG.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = clearBG
        }
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
        } else { cell.episodeImage.image = #imageLiteral(resourceName: "noImage") }
    }
    
    private func setCellText(ep: showEpisode, cell: showEpisodesTableViewCell) {
        cell.episodeNameLabel.text = ep.name
        cell.seasonEpisodeLabel.text = "S\(ep.season) E\(ep.number)"
        if let epRuntime = ep.runtime {
            cell.runTimeLabel.text = "\(epRuntime) min"
        } else {
            cell.runTimeLabel.text = ""
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

