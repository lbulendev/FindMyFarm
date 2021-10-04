//
//  ViewController.swift
//  FindWinery
//
//  Created by Larry Bulen on 9/26/21.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    private var carPlayManager = CarPlayManager()
    private var currentPlace: CLPlacemark?

    private var placesClient: GMSPlacesClient = {
        let placesClient = GMSPlacesClient()
        return placesClient
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configureConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.backgroundColor = .orange
    }

    private func presentAlert(message: String) {
      let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

      present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carPlayManager.dataManager?.farms.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        guard let farms = carPlayManager.dataManager?.farms else { return UITableViewCell() }
        let farm = farms[indexPath.row]
        cell.textLabel?.text = "Farm: \(farm.name ?? "no name"), (lat,long): (\(farm.location?.0 ?? 0),\(farm.location?.1 ?? 0))"
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let farms = carPlayManager.dataManager?.farms else { return }
        let farm = farms[indexPath.row]
        

        let location = CLLocationCoordinate2D(latitude: farm.location?.0 ?? 0,
                                              longitude: farm.location?.1 ?? 0)
        let mapVC = GoogleMapViewController(placesClient: placesClient)
        mapVC.destinationLocation = location
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}
