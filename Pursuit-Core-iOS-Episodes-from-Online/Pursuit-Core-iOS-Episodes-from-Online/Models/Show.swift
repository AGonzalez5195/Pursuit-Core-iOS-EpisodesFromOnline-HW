//
//  Shows.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import Foundation

struct Show: Codable {
    let name: String
    let image: Image
    let rating: Rating?
    let id: Int
    let externals: Externals
    let genres: [Genre]
    
    enum Genre: String, Codable {
        case action = "Action"
        case adventure = "Adventure"
        case anime = "Anime"
        case comedy = "Comedy"
        case crime = "Crime"
        case drama = "Drama"
        case espionage = "Espionage"
        case family = "Family"
        case fantasy = "Fantasy"
        case history = "History"
        case horror = "Horror"
        case legal = "Legal"
        case medical = "Medical"
        case music = "Music"
        case mystery = "Mystery"
        case romance = "Romance"
        case scienceFiction = "Science-Fiction"
        case sports = "Sports"
        case supernatural = "Supernatural"
        case thriller = "Thriller"
        case war = "War"
        case western = "Western"
    }
    
    static func getShowData(completionHandler: @escaping (Result<[Show],AppError>) -> () ) {
        let url = "http://api.tvmaze.com/shows"
        
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let showData = try JSONDecoder().decode([Show].self, from: data)
                    completionHandler(.success(showData))
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
    
    static func getSortedArray(arr: [Show]) -> [Show] {
        let sortedArr = arr.sorted{$0.name < $1.name}
        return sortedArr
    }
    
    static func getFilteredShowsByName(arr: [Show], searchString: String) -> [Show] {
        return arr.filter{$0.name.lowercased().contains(searchString.lowercased())}
    }
    static func getFilteredShowsByGenre(arr: [Show], searchString: String) -> [Show] {
        return arr.filter{$0.genres.joinedStringFromArray.lowercased().contains(searchString.lowercased())}
    }
    
}

struct Image: Codable {
    let original: String
}

struct Rating: Codable {
    let average: Double?
}

struct Externals: Codable {
    let tvrage: Int
}

