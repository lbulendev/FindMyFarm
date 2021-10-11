//
//  RouteSelectionViewController.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 10/9/21.
//

import UIKit
import CoreLocation
import MapKit

class RouteSelectionViewController: UIViewController {
    private var carPlayManager = CarPlayManager()

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var farm: FarmModel? = nil
    private var mapRoutes: [MKRoute] = []

    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.66),

            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init(farm: FarmModel) {
        super.init(nibName: nil, bundle: nil)
        self.farm = farm
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        guard let startCoordinate = carPlayManager.locationManager?.location?.coordinate else { return }
        let startPlacemark = MKPlacemark.init(coordinate: startCoordinate)
        let startMapItem = MKMapItem(placemark: startPlacemark)
        startMapItem.name = "My Location"
        let startAnnotation = RouteAnnotation.init(item: startMapItem)
        let stopCoordinate = CLLocationCoordinate2D.init(latitude: farm?.location?.0 ?? 0, longitude: farm?.location?.1 ?? 0)
        let stopPlacemark = MKPlacemark.init(coordinate: stopCoordinate)
        let stopMapItem = MKMapItem(placemark: stopPlacemark)
        stopMapItem.name = farm?.name ?? "Unknown"
        let stopAnnotation = RouteAnnotation.init(item: stopMapItem)
        guard let routes = farm?.routes else { return }
        for route in routes {
            updateView(with: route)
        }
        mapView.showAnnotations([startAnnotation, stopAnnotation], animated: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(mapView)
        view.addSubview(tableView)

        configureConstraints()
    }

    private func updateView(with mapRoute: MKRoute) {
        let padding: CGFloat = 8

        mapView.addOverlay(mapRoute.polyline)
        mapView.setVisibleMapRect(
            mapView.visibleMapRect.union(
                mapRoute.polyline.boundingMapRect
            ),
            edgePadding: UIEdgeInsets(
                top: 0,
                left: padding,
                bottom: padding,
                right: padding
            ),
            animated: true
        )
        mapRoutes.append(mapRoute)
    }

}

extension RouteSelectionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        switch mapView.overlays.count {
        case 1:
            renderer.strokeColor = .systemBlue
        case 2:
            renderer.strokeColor = .systemRed
        default:
            renderer.strokeColor = .systemYellow
        }
      renderer.lineWidth = 3
      return renderer
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation,
                        regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
        center: location.coordinate,
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension RouteSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farm?.routes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        let route = farm?.routes?[indexPath.row]
        let hours = floor((route?.expectedTravelTime ?? 0) / 60.0 / 60.0)
        let minutes = floor(floor((route?.expectedTravelTime ?? 0) - (hours * 60.0 * 60.0)) / 60.0)
        let distance = (route?.distance ?? 0) / 1609.34
        cell.textLabel?.text = "\(route?.name ?? ""); \(String(format:"%.2f", distance)) miles; \(String(format:"%.0f", hours)):\(String(format:"%.0f", minutes))"
        return cell
    }
    
}

extension RouteSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let route = farm?.routes?[indexPath.row],
              let turnVC = TurnNavigationViewController(route: route) else { return }
        self.navigationController?.pushViewController(turnVC, animated: true)
    }
}
