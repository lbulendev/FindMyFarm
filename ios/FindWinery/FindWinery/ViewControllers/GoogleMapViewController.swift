//
//  GoogleMapViewController.swift
//  FindWinery
//
//  Created by Larry Bulen on 9/27/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapViewController: UIViewController {
    private var carPlayManager = CarPlayManager()
    var destinationLocation: CLLocationCoordinate2D?
    let geocoder = GMSGeocoder()
    var placesClient: GMSPlacesClient
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0

    lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .normal
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        return mapView
    }()

    lazy var destinationMarker: GMSMarker = {
        let marker = GMSMarker()
//        marker.icon = UIImage(named: "FW-map-pin")
        return marker
    }()

    required init(placesClient: GMSPlacesClient) {
        self.placesClient = placesClient
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func loadView() {
        super.loadView()
        destinationMarker.map = mapView
        guard let currentLocation = carPlayManager.locationManager?.location?.coordinate else { return }
        let myMarker = GMSMarker.init(position: currentLocation)
        myMarker.icon = UIImage(named: "FW-map-pin")
        myMarker.map = mapView
        guard let location = destinationLocation else { return }
        destinationMarker.position = location
        destinationMarker.icon = UIImage(named: "FW-map-pin")
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 6)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

//        mapView.showAnnotations(route.annotations, animated: false)
//        groupAndRequestDirections()
        view.addSubview(mapView)
        configureConstraints()
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
//        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
//            guard error == nil else {
//                return
//            }
//
//            if let result = response?.firstResult() {
//                let marker = GMSMarker()
//                marker.position = cameraPosition.target
//                marker.title = result.lines?[0]
//                marker.map = mapView
//            }
//        }
//    }
}

