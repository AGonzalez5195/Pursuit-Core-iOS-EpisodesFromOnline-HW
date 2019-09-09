//
//  Shows.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import Foundation

struct Shows: Codable {
    let name: String
    let image: Image
    let rating: Rating?
    static func getShowData(completionHandler: @escaping (Result<[Shows],AppError>) -> () ) {
        let url = "http://api.tvmaze.com/shows"
        
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let showData = try JSONDecoder().decode([Shows].self, from: data)
                    completionHandler(.success(showData))
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}

struct Image: Codable {
    let original: String
}

struct Rating: Codable {
    let average: Double?
}
