//
//  RickAndMortyModel.swift
//  RickAndMorty
//
//  Created by Anna Lavrova on 12.03.2024.
//

import Foundation

struct RickAndMortyModel: Decodable {
    let persons: [Person]

    enum CodingKeys: String, CodingKey {
        case persons = "results"
    }
}

extension RickAndMortyModel {

    struct Person: Decodable {
        let id: Int
        let name: String
        let status: Status
        let type: String
        let gender: Gender
        let location: Location
        let image: String
        let episode: [String]

        enum Status: String, Decodable {
            case alive = "Alive"
            case dead = "Dead"
            case unknown = "unknown"
        }

        enum Gender: String, Decodable {
            case female = "Female"
            case male = "Male"
            case unknown = "unknown"
        }
    }
}

extension RickAndMortyModel.Person {

    struct Location: Decodable {
        let name: String
        let url: String
    }
}
