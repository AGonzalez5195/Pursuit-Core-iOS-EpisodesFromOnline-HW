//
//  PersonViewController.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/12/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

//class PersonViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    //MARK: -- Properties
//    var people = [PersonElement]() {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//    var currentPersonURL = String()
//   
//    private func getSelectedPersonData(newPersonURL: String){
//        PersonElement.getPersonData(str: newPersonURL ) { (result) in
//            DispatchQueue.main.async {
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let newPeopleData):
//                    self.people = newPeopleData
//                }
//            }
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
//        getSelectedPersonData(newPersonURL: currentPersonURL)
//    }
//}
//
////MARK: -- Datasource Methods
//extension PersonViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return people.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let currentPerson = people[indexPath.row]
//        let personCell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
//        cell.t
//        
//
//        return personCell
//    }
//}
//
////MARK: -- Delegate Methods
//
//extension PersonViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 250
//    }
//}


