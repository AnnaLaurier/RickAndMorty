//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Anna Lavrova on 12.03.2024.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func fetchCharacters(
        completionQueue: DispatchQueue,
        completion: @escaping (Result<[RickAndMortyModel.Person], Error>) -> Void
    ) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            return
        }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data else { return }

            do {
                let rickAndMortyModel = try JSONDecoder().decode(RickAndMortyModel.self, from: data)
                completionQueue.async {
                    completion(.success(rickAndMortyModel.persons))
                }
            } catch {
                completionQueue.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func fetchDetails(
        personID: Int?,
        completionQueue: DispatchQueue,
        completion: @escaping (Result<RickAndMortyModel.Person, Error>) -> Void
    ) {
        guard let personID else {
            return
        }

        guard let url = URL(string: "https://rickandmortyapi.com/api/character/\(personID)") else {
            return
        }

        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data else { return }

            do {
                let person = try JSONDecoder().decode(RickAndMortyModel.Person.self, from: data)
                completionQueue.async {
                    completion(.success(person))
                }
            } catch {
                completionQueue.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
