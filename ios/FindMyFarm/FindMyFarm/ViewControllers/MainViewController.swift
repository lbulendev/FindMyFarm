//
//  MainViewController.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/17/21.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController {
    private var carPlayManager = CarPlayManager()

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
        print("carPlayManager.locationManager?.location: \(carPlayManager.locationManager?.location)")
    }

    private func presentAlert(message: String) {
      let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

      present(alertController, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
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
//        cell.textLabel?.text = farm.name
//        cell.detailTextLabel?.text = "Crop: \(farm.crop), Size: \(farm.size)"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Farm: \(farm.name ?? "no name") (lat,long): (\(farm.location?.0 ?? 0),\(farm.location?.1 ?? 0))\n Crop: \(farm.crop ?? "No Crop")\n Size: \(farm.size ?? "No size")"
        return cell
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segment: RouteBuilder.Segment?
        let farmList = carPlayManager.dataManager?.farms ?? []
        if let currentLocation = carPlayManager.locationManager?.location {
          segment = .location(currentLocation)
        } else {
          segment = nil
        }

        let stopSegments: [RouteBuilder.Segment] = [
            farmList[indexPath.row].name
        ]
        .compactMap { contents in
          if let value = contents {
            return .text(value)
          } else {
            return nil
          }
        }

        guard
          let originSegment = segment,
          !stopSegments.isEmpty
          else {
            self.presentAlert(message: "Please select an origin and at least 1 stop.")
            return
        }

        RouteBuilder.buildRoute(
          origin: originSegment,
          stops: stopSegments,
          within: carPlayManager.locationManager?.currentRegion
        ) { result in

          switch result {
          case .success(let route):
            let mapVC = MapViewController(route: route)
            self.navigationController?.pushViewController(mapVC, animated: true)

          case .failure(let error):
            let errorMessage: String

            switch error {
            case .invalidSegment(let reason):
              errorMessage = "There was an error with: \(reason)."
            }

            self.presentAlert(message: errorMessage)
          }
        }
    }
}
