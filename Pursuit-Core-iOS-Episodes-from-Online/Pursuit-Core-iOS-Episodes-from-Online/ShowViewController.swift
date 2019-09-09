//
//  ViewController.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Benjamin Stone on 9/5/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class showViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var shows = [Shows]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var filteredShows: [Shows] {
        get {
            guard let searchString = searchString else { return shows }
            guard searchString != ""  else { return shows }
            return Shows.getFilteredShows(arr: shows, searchString: searchString)
        }
    }
    
    var searchString: String? = nil { didSet { self.tableView.reloadData()} }
    
    private func loadData(){
        Shows.getShowData { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let showData):
                    self.shows = showData
                    self.shows = Shows.getSortedArray(arr: self.shows)
                }
            }
        }
    }
    
    private func configureDelegateDataSources(){
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegateDataSources()
        loadData()
    }
}

extension showViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredShows.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentShow = filteredShows[indexPath.row]
        let showCell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowTableViewCell
        
        showCell.showNameLabel.text = currentShow.name
        showCell.showRatingLabel.text = "Rating: \(currentShow.rating?.average ?? 0.0)"
        ImageHelper.shared.fetchImage(urlString: currentShow.image.original) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromOnline):
                    showCell.showImage.image = imageFromOnline
                }
            }
        }
        return showCell
    }
}

//MARK: -- Delegate Methods

extension showViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


extension showViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
}
