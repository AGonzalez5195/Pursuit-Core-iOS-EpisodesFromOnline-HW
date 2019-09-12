//
//  ViewController.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Benjamin Stone on 9/5/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class showViewController: UIViewController {
    //MARK: -- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: -- Properties
    var shows = [TVMaze]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var filteredShows: [TVMaze] {
        get {
            guard searchString != ""  else { return shows }
            switch searchBar.selectedScopeButtonIndex {
            case 0: return Show.getFilteredShowsByName(arr: shows, searchString: searchString)
            case 1: return Show.getFilteredShowsByGenre(arr: shows, searchString: searchString)
            default: return shows
            }
        }
    }
    
    
    var searchString = "" {
        didSet {
            let userEnteredString = searchString.replacingOccurrences(of: " ", with: "%20").lowercased()
            loadData(newString: userEnteredString)
        }
    }
    
    //MARK: -- Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else {fatalError("No identifier in segue")}
        
        switch segueIdentifer {
        case "segueToEpisodes":
            guard let destVC = segue.destination as? SpecificShowViewController else { fatalError("Unexpected segue VC") }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("No row selected") }
            let selectedShow = filteredShows[selectedIndexPath.row]
            let selectedShowIDURl = "http://api.tvmaze.com/shows/\(selectedShow.show.id)/episodes"
            destVC.currentShowURL = selectedShowIDURl
            destVC.navigationItem.title = selectedShow.show.name
            let backItem = UIBarButtonItem()
            backItem.title = "Shows"
            navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
            
        default:
            fatalError("unexpected segue identifier")
        }
    }
    
    private func loadData(newString: String){
        TVMaze.getShowData(searchStr: newString) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let showData):
                    self.shows = showData
                }
            }
        }
    }
    
    private func configureDelegateDataSources(){
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    private func setCellDesign(cell: ShowTableViewCell){
        [cell.showNameLabel, cell.genreLabel].forEach{$0?.textColor = .white}
        cell.backgroundColor = .clear
        let clearBGView = UIView()
        clearBGView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = clearBGView
    }
    
    private func setCellImage(show: Show, cell: ShowTableViewCell) {
        if let showImage = show.image?.original {
            ImageHelper.shared.fetchImage(urlString: showImage) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let imageFromOnline):
                        cell.showImage.image = imageFromOnline
                    }
                }
            }
        } else {
            cell.showImage.image = UIImage(named: "noImage")
        }
    }
    
    private func setCellText(show: Show, cell: ShowTableViewCell){
        cell.showNameLabel.text = show.name
        cell.showRatingLabel.text = "Rating: \(show.rating?.average ?? 0.0)"
        cell.genreLabel.text = "\(show.genres.joinedStringFromArray.capitalized)"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegateDataSources()
    }
}

//MARK: -- Datasource Methods
extension showViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showCell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowTableViewCell
        let currentShow = filteredShows[indexPath.row]
        setCellDesign(cell: showCell)
        setCellText(show: currentShow.show, cell: showCell)
        setCellImage(show: currentShow.show, cell: showCell)
        
        return showCell
    }
}

//MARK: -- Delegate Methods

extension showViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
}


extension showViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchString = searchText
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsScopeBar = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.sizeToFit()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.sizeToFit()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.sizeToFit()
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        tableView.reloadData()
    }
}

