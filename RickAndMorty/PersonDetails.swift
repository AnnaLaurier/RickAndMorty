//
//  PersonDetails.swift
//  RickAndMorty
//
//  Created by Anna Lavrova on 12.03.2024.
//

import UIKit

final class PersonDetails: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var personID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetails()

    }

    func fetchDetails() {
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
                print(person)
                DispatchQueue.main.async {
                    self.navigationItem.title = person.name
                    self.imageView.kf.setImage(with: URL(string: person.image))
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}


