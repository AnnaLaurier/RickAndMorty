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

    private func fetchCharacters() {
        NetworkService.shared.fetchCharacters(completionQueue: .main) { [weak self] result in
            switch result {
            case .success(let persons):
                self?.persons = persons
                self?.tableView.reloadData()
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
