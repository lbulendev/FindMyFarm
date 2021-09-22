//
//  MainViewController.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/17/21.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?
    private var currentRegion: MKCoordinateRegion?

    var farmList: [[FarmModel]] = [
        [
            FarmModel(name: "Napa, CA", location: (38.2975, -122.2869)),
            FarmModel(name: "Purdon, TX", location: (31.9490, -96.6167))
        ],
        [
            FarmModel(name: "Castello di Amorosa", location: (38.5586, -122.5428)),
            FarmModel(name: "Stirling Winery", location: (40.6685, -74.4881))
        ],
        [
            FarmModel(name: "Baguio, PH", location: (16.4023, 120.5960)),
            FarmModel(name: "Manila, PH", location: (14.5995, 120.9842))
        ],
        [
            FarmModel(name: "Grand Canyon Village", location: (36.0544, -112.1401)),
            FarmModel(name: "Yellowstone NP", location: (44.4280, -110.5885)),
            FarmModel(name: "Yosemite NP", location: (37.8651, -119.5383))
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

extension MainViewController: CLLocationManagerDelegate {
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
        let commonDelta: CLLocationDegrees = 25 / 111 // 1/111 = 1 latitude km
        let span = MKCoordinateSpan(latitudeDelta: commonDelta, longitudeDelta: commonDelta)
        let region = MKCoordinateRegion(center: firstLocation.coordinate, span: span)

        currentRegion = region
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Swift.Error) {
        print("error:: \(error)")
    }
}

extension MainViewController: UITableViewDataSource {
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

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segment: RouteBuilder.Segment?
        if let currentLocation = currentPlace?.location {
          segment = .location(currentLocation)
        } else {
          segment = nil
        }

        let stopSegments: [RouteBuilder.Segment] = [
            farmList[indexPath.section][indexPath.row].name
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
          within: currentRegion
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
