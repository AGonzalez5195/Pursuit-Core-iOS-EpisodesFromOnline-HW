//
//  specificShow.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import Foundation

struct showEpisode: Codable {
    let name: String
    let image: EpisodeImage?
    let season: Int
    let number: Int
    let summary: String?
    let runtime: Int?
    let airdate: String
    
    static func getEpisodeData(showURL: String, completionHandler: @escaping (Result<[showEpisode],AppError>) -> () ) {
        
        NetworkManager.shared.fetchData(urlString: showURL) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let showEpisodeData = try JSONDecoder().decode([showEpisode].self, from: data)
                    completionHandler(.success(showEpisodeData))
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}

struct EpisodeImage: Codable {
    let original: String
}
