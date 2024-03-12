//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Anna Lavrova on 11.03.2024.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var persons: [RickAndMortyModel.Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCharacters()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let viewController = segue.destination as? PersonDetails
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        viewController?.personID = persons[indexPath.row].id
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    func getImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(value.image)
                }

            case .failure(let error):
                print(error)
            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PersonCell else {
            return UITableViewCell()
        }

        let person = persons[indexPath.row]

        cell.nameLabel.text = person.name
        cell.personImageView.kf.setImage(with: URL(string: person.image))
        cell.personImageView.layer.cornerRadius = 16
        cell.personImageView.layer.cornerCurve = .continuous

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
