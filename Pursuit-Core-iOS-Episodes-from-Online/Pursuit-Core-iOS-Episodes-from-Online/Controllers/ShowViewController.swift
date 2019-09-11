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
    var shows = [Show]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var filteredShows: [Show] {
        get {
            guard let searchString = searchString else { return shows }
            guard searchString != ""  else { return shows }
            return Show.getFilteredShows(arr: shows, searchString: searchString)
        }
    }
    
    
    var searchString: String? = nil { didSet { self.tableView.reloadData()} }
    
    //MARK: -- Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else {fatalError("No identifier in segue")}
        
        switch segueIdentifer {
        case "segueToEpisodes":
            guard let destVC = segue.destination as? SpecificShowViewController else { fatalError("Unexpected segue VC") }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("No row selected") }
            let selectedShow = filteredShows[selectedIndexPath.row]
            let selectedShowIDURl = "http://api.tvmaze.com/shows/\(selectedShow.id)/episodes"
            destVC.currentShowURL = selectedShowIDURl
            destVC.navigationItem.title = selectedShow.name
            let backItem = UIBarButtonItem()
            backItem.title = "Shows"
            navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
            
            
        default:
            fatalError("unexpected segue identifier")
        }
    }
    
    private func loadData(){
        Show.getShowData { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let showData):
                    self.shows = showData
                    self.shows = Show.getSortedArray(arr: self.shows)
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
    
    private func setCellImage(ep: Show, cell: ShowTableViewCell) {
        ImageHelper.shared.fetchImage(urlString: ep.image.original) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromOnline):
                    cell.showImage.image = imageFromOnline
                }
            }
        }
    }
    
    private func setCellText(ep: Show, cell: ShowTableViewCell){
        cell.showNameLabel.text = ep.name
        cell.showRatingLabel.text = "Rating: \(ep.rating?.average ?? 0.0)"
        cell.genreLabel.text = "\(ep.genres.joinedStringFromArray.capitalized)"
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
        loadData()
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
        setCellText(ep: currentShow, cell: showCell)
        setCellImage(ep: currentShow, cell: showCell)
        
        return showCell
    }
}

//MARK: -- Delegate Methods

extension showViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}


extension showViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
