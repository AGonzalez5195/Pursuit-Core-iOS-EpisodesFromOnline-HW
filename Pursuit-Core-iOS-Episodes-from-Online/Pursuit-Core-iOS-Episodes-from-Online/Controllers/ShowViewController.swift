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
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    
    //MARK: -- Properties
    var effect: UIVisualEffect!
    var shows = [TVMaze]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var searchString = "" {
        didSet {
            let userEnteredString = searchString.replacingOccurrences(of: " ", with: "+").lowercased()
            loadData(newString: userEnteredString)
        }
    }
    
    
    
    //MARK: --IBActions
    @IBAction func showPopup(_ sender: UIButton) {
        animateIn()
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        animateOut()
    }
    //MARK: -- Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else {fatalError("No identifier in segue")}
        
        switch segueIdentifer {
        case "segueToEpisodes":
            guard let destVC = segue.destination as? SpecificShowViewController else { fatalError("Unexpected segue VC") }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("No row selected") }
            let selectedShow = shows[selectedIndexPath.row]
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
        TVMaze.getShowData(str: newString) { (result) in
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
        [cell.showNameLabel, cell.genreLabel].forEach{$0?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)}
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
        } else { cell.showImage.image = #imageLiteral(resourceName: "noImage") }
    }
    
    private func setCellText(show: Show, cell: ShowTableViewCell){
        cell.showNameLabel.text = show.name
        if let showRating = show.rating?.average {
            cell.showRatingLabel.text = "Rating: \(showRating)"
        } else {
            cell.showRatingLabel.text = "No Rating Available"
        }
        cell.genreLabel.text = show.genres?.joinedStringFromArray.capitalized

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
    
    private func animateIn() {
        self.view.addSubview(popUpView)
        popUpView.center = self.view.center
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        popUpView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.isHidden = false
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOut() {
        UIView.animate(withDuration: 0.3, animations:{
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0
            self.visualEffectView.effect = nil
        }) {(success: Bool) in
            self.popUpView.removeFromSuperview()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegateDataSources()
        visualEffectView.isHidden = true
        popUpView.layer.cornerRadius = 20
        
    }
}

//MARK: -- Datasource Methods
extension showViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showCell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowTableViewCell
        let currentShow = shows[indexPath.row]
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
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        tableView.reloadData()
    }
}






//var filteredShows: [TVMaze] {
//    get {
//        guard searchString != ""  else { return shows }
//        switch searchBar.selectedScopeButtonIndex {
//        //            case 0: return Show.getFilteredShowsByName(arr: shows, searchString: searchString)
//        case 1: return Show.getFilteredShowsByGenre(arr: shows, searchString: searchString)
//        default: return shows
//        }
//    }
//}
//
