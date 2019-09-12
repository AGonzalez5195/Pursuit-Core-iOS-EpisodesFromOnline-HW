//
//  Person.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Anthony Gonzalez on 9/12/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import Foundation

// MARK: - PersonElement
struct PersonElement: Codable {
    let person: Person
    
    static func getPersonData(str: String, completionHandler: @escaping (Result<[PersonElement],AppError>) -> () ) {
        let url = "http://api.tvmaze.com/search/people?q=" + str
        
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let personData = try JSONDecoder().decode([PersonElement].self, from: data)
                    completionHandler(.success(personData))
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}


// MARK: - PersonClass
struct Person: Codable {
//    let id: Int
    let name: String
//    let country: Country?
//    let birthday: String?
//    let deathday: JSONNull?
//    let gender: String?
//    let image: PersonImage?
 
}

// MARK: - Country
struct Country: Codable {
    let name, code, timezone: String
}

// MARK: - Image
struct PersonImage: Codable {
    let medium, original: String
}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        // No-op
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
