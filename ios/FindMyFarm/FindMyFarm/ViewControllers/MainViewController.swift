//
//  MainViewController.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/17/21.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    private var carPlayManager = CarPlayManager()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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
        view.backgroundColor = .orange
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.register(FarmTableViewCell.self, forCellReuseIdentifier: FarmTableViewCell.reuseId)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        configureConstraints()
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carPlayManager.dataManager?.farms.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FarmTableViewCell.reuseId) as? FarmTableViewCell else { return FarmTableViewCell.init(style: .default, reuseIdentifier: FarmTableViewCell.reuseId) }
        guard let farms = carPlayManager.dataManager?.farms else { return UITableViewCell() }
        let farm = farms[indexPath.row]
        cell.farmNameLabel.text = farm.name
        cell.cropTypeLabel.text = farm.crop
        let latitude = farm.location?.0 ?? 0
        let longitude = farm.location?.1 ?? 0
        var location = "(\(latitude), \(longitude))"
        if longitude == 0 && latitude == 0 {
            location = "--"
        }
        cell.locationCoordinatesLabel.text = location
        let request = MKDirections.Request()
        let startCoordinate = CLLocationCoordinate2D.init(latitude: carPlayManager.locationManager?.location?.coordinate.latitude ?? 0, longitude: carPlayManager.locationManager?.location?.coordinate.longitude ?? 0)
        let startPlaceMark = MKPlacemark.init(coordinate: startCoordinate)
        let startItem = MKMapItem.init(placemark: startPlaceMark)

        let desitnationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let destinationPlaceMark = MKPlacemark.init(coordinate: desitnationCoordinate)
        let destinationItem = MKMapItem.init(placemark: destinationPlaceMark)

        request.source = startItem
        request.destination = destinationItem
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            self.carPlayManager.dataManager?.farms[indexPath.row].routes = response?.routes
            let hours = floor(route.expectedTravelTime / 60.0 / 60.0)
            let minutes = floor(floor(route.expectedTravelTime - (hours * 60.0 * 60.0)) / 60.0)
            let distance = route.distance / 1609.34
            cell.distanceAmountLabel.text = "\(String(format:"%.2f", distance)) miles"
            cell.timeAmountLabel.text = "\(String(format:"%.0f", hours)):\(String(format:"%.0f", minutes)) hours"
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let farm = carPlayManager.dataManager?.farms[indexPath.row] else { return }
        let farmVC = RouteSelectionViewController(farm: farm)
        self.navigationController?.pushViewController(farmVC, animated: true)
    }
}
