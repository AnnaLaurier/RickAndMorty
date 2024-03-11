//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Anna Lavrova on 11.03.2024.
//

import UIKit

class ViewController: UIViewController {

    private var persons: [RickAndMortyModel.Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCharacters()
    }

    func fetchCharacters() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            return
        }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data else { return }

            do {
                let rickAndMortyModel = try JSONDecoder().decode(RickAndMortyModel.self, from: data)
                self.persons = rickAndMortyModel.persons
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

}

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
