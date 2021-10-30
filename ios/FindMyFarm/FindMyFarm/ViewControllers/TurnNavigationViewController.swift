//
//  TurnNavigationViewController.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 10/10/21.
//

import UIKit
//import CoreLocation
import MapKit

class TurnNavigationViewController: UIViewController {
    private var carPlayManager = CarPlayManager()
    private var currentRoute: MKRoute? = nil
    private var currentStepIndex = 8
    private var farm: FarmModel? = nil

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }()

    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .blue
        label.numberOfLines = 0
        return label
    }()

    lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .blue
        label.numberOfLines = 0
        return label
    }()

    lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .red
        label.numberOfLines = 0
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.50),
            noticeLabel.topAnchor.constraint(equalTo: mapView.topAnchor),
            noticeLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            noticeLabel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            noticeLabel.heightAnchor.constraint(equalToConstant: 20.0),
            instructionsLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            instructionsLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            instructionsLabel.heightAnchor.constraint(equalToConstant: 20.0),
            instructionsLabel.widthAnchor.constraint(equalToConstant: mapView.frame.size.width * 0.6),
            instructionsLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),

            distanceLabel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            distanceLabel.heightAnchor.constraint(equalToConstant: 20.0),
            distanceLabel.widthAnchor.constraint(equalToConstant: mapView.frame.size.width * 0.35),
            distanceLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(mapView)
        view.addSubview(tableView)
        view.addSubview(distanceLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(noticeLabel)

        configureConstraints()
        getDirections()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init?(farm: FarmModel, route: MKRoute) {
        self.currentRoute = route
        self.farm = farm

        super.init(nibName: nil, bundle: nil)
    }

    func getDirections() {
        let request = MKDirections.Request()
        // Source
        let sourceLat = carPlayManager.locationManager?.currentPlace?.location?.coordinate.latitude ?? +37.33213110
        let sourceLong = carPlayManager.locationManager?.currentPlace?.location?.coordinate.longitude ?? -122.02990105
        let sourceCoordinate = CLLocationCoordinate2D.init(latitude: sourceLat,
                                                           longitude: sourceLong)
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
//        let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 39.058, longitude: -100.21))
        request.source = MKMapItem(placemark: sourcePlaceMark)
        // Destination
        let destCoordinate = CLLocationCoordinate2D.init(latitude: farm?.location?.0 ?? 0,
                                                         longitude: farm?.location?.1 ?? 0)
        let destPlaceMark = MKPlacemark(coordinate: destCoordinate)
//        let destPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.79, longitude: -98.64))
        request.destination = MKMapItem(placemark: destPlaceMark)
        // Transport Types
        request.transportType = [.automobile, .walking]

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "No error specified").")
                return
            }

            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)

            self.currentRoute = route
            self.displayCurrentStep()
        }
    }

    func displayCurrentStep() {
        guard let currentRoute = currentRoute else { return }
        if currentStepIndex >= currentRoute.steps.count { return }
        let step = currentRoute.steps[currentStepIndex]

        instructionsLabel.text = step.instructions
//        distanceLabel.text = "\(distanceConverter(distance: step.distance))"
        distanceLabel.text = "\(step.distance) meters"

        // Hide the noticeLabel if notice doesn't exist
        if step.notice != nil {
            noticeLabel.isHidden = false
            noticeLabel.text = step.notice
        } else {
            noticeLabel.isHidden = true
        }

        // Enable/Disable buttons according to the step they are
//        previousStepBtn.isEnabled = currentStepIndex > 0
//        nextStepBtn.isEnabled = currentStepIndex < (currentRoute.steps.count - 1)

        // Add padding around the route
        let padding = UIEdgeInsets(top: 40, left: 40, bottom: 100, right: 40)
        mapView.setVisibleMapRect(step.polyline.boundingMapRect, edgePadding: padding, animated: true)
//        mapView.setVisibleMapRect(step.polyline.boundingMapRect, edgePadding: .zero, animated: true)
    }}

extension TurnNavigationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 3
        return renderer
    }
}

extension TurnNavigationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return correctedRoute?.steps.count ?? 0
        return currentRoute?.steps.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        cell.textLabel?.text = currentRoute?.steps[indexPath.row].instructions
        return cell
    }
}

extension TurnNavigationViewController: UITableViewDelegate {
}

