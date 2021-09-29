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
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        return locationManager
    }()

    private var placesClient: GMSPlacesClient = {
        let placesClient = GMSPlacesClient()
        return placesClient
    }()

    private var currentPlace: CLPlacemark?

    var farmList: [[FarmModel]] = [
        [
            FarmModel(name: "Napa, CA", crop: "Grapes", location: (38.2975, -122.2869)),
            FarmModel(name: "Purdon, TX", crop: "Grass", location: (31.9490, -96.6167))
        ],
        [
            FarmModel(name: "Castello di Amorosa", crop: "Grapes", location: (38.5586, -122.5428)),
            FarmModel(name: "Stirling Winery", crop: "Grapes", location: (40.6685, -74.4881))
        ],
        [
            FarmModel(name: "Baguio, PH", crop: "Strawberries", location: (16.4023, 120.5960)),
            FarmModel(name: "Manila, PH", crop: "Coconuts", location: (14.5995, 120.9842))
        ],
        [
            FarmModel(name: "Grand Canyon Village", crop: "Grass", location: (36.0544, -112.1401)),
            FarmModel(name: "Yellowstone NP", crop: "Grass", location: (44.4280, -110.5885)),
            FarmModel(name: "Yosemite NP", crop: "Grass", location: (37.8651, -119.5383))
        ]
    ]

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
        attemptLocationAccess()
    }

    func attemptLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        switch self.locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestLocation()
        }
    }

    private func presentAlert(message: String) {
      let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

      present(alertController, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            guard let firstPlace = places?.first else { return }
            self.currentPlace = firstPlace
            print("currentPlace: \(self.currentPlace)")
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Swift.Error) {
        print("error:: \(error)")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return farmList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farmList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        cell.textLabel?.text = "Farm: \(farmList[indexPath.section][indexPath.row].name ?? "no name"), (lat,long): (\(farmList[indexPath.section][indexPath.row].location?.0 ?? 0),\(farmList[indexPath.section][indexPath.row].location?.1 ?? 0))"
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = CLLocationCoordinate2D(latitude: farmList[indexPath.section][indexPath.row].location?.0 ?? 0,
                                              longitude: farmList[indexPath.section][indexPath.row].location?.1 ?? 0)
        let mapVC = GoogleMapViewController(locationManager: locationManager, placesClient: placesClient)
        mapVC.currentLocation = location
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}
