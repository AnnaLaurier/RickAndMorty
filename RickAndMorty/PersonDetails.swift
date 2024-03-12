//
//  PersonDetails.swift
//  RickAndMorty
//
//  Created by Anna Lavrova on 12.03.2024.
//

import UIKit

final class PersonDetails: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameOfPerson: UILabel!
    @IBOutlet weak var genderOfPerson: UILabel!
    @IBOutlet weak var allInformationLabel: UILabel!

    var personID: Int?

    private var person: RickAndMortyModel.Person?

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDetails()
    }

    func fetchDetails() {
        NetworkService.shared.fetchDetails(
            personID: personID,
            completionQueue: .main
        ) { [weak self] result in
            switch result {
            case .success(let person):
                self?.person = person
                self?.updateView()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func updateView() {
        guard let person else { return }

        navigationItem.title = person.name
        imageView.kf.setImage(with: URL(string: person.image))
        nameOfPerson.text = person.name
        genderOfPerson.text = "Gender: \(person.gender.rawValue)"
        allInformationLabel.text = "Status: \(person.status.rawValue)"
    }
}


