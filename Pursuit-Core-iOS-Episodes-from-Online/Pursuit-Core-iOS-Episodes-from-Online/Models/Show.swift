//
//  Shows.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import Foundation

struct TVMaze: Codable {
    let show: Show
    
    static func getShowData(str: String, completionHandler: @escaping (Result<[TVMaze],AppError>) -> () ) {
        let url = "http://api.tvmaze.com/search/shows?q=\(str)"
        
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                print(url)
            case .success(let data):
                do {
                    let showData = try JSONDecoder().decode([TVMaze].self, from: data)
                    completionHandler(.success(showData))
                    print(url)
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}

struct Show: Codable {
    let name: String
    let image: Image?
    let rating: Rating?
    let id: Int
    let genres: [Genre]?
    
    enum Genre: String, Codable {
        case action = "Action"
        case adventure = "Adventure"
        case anime = "Anime"
        case children = "Children"
        case comedy = "Comedy"
        case crime = "Crime"
        case drama = "Drama"
        case diy = "DIY"
        case espionage = "Espionage"
        case family = "Family"
        case fantasy = "Fantasy"
        case food = "Food"
        case history = "History"
        case horror = "Horror"
        case legal = "Legal"
        case medical = "Medical"
        case music = "Music"
        case mystery = "Mystery"
        case nature = "Nature"
        case romance = "Romance"
        case scienceFiction = "Science-Fiction"
        case sports = "Sports"
        case supernatural = "Supernatural"
        case thriller = "Thriller"
        case travel = "Travel"
        case war = "War"
        case western = "Western"
    }
}

struct Image: Codable {
    let original: String
}

struct Rating: Codable {
    let average: Double?
}


