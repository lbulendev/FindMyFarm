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
    var locationManager: CLLocationManager
    var destinationLocation: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    let geocoder = GMSGeocoder()

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

    required init(locationManager: CLLocationManager, placesClient: GMSPlacesClient) {
        self.locationManager = locationManager
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
        guard let currentLocation = locationManager.location?.coordinate  else { return }
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

// Delegates to handle events for the location manager.
extension GoogleMapViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // Check accuracy authorization
    let accuracy = manager.accuracyAuthorization
    switch accuracy {
    case .fullAccuracy:
        print("Location accuracy is precise.")
    case .reducedAccuracy:
        print("Location accuracy is not precise.")
    @unknown default:
      fatalError()
    }

    // Handle authorization status
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
