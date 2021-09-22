//
//  MapViewController.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/17/21.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    var initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var model = FarmModel(name: "Blah", location: (0, 0))
    private let route: Route
    private var mapRoutes: [MKRoute] = []
    private var groupedRoutes: [(startItem: MKMapItem, endItem: MKMapItem)] = []

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }()

    init(route: Route) {
        self.route = route
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showAnnotations(route.annotations, animated: false)
        groupAndRequestDirections()
        view.addSubview(mapView)
        configureConstraints()
    }

    private func groupAndRequestDirections() {
        guard let firstStop = route.stops.first else {
            return
        }
        
        groupedRoutes.append((route.origin, firstStop))
        
        if route.stops.count == 2 {
            let secondStop = route.stops[1]
            
            groupedRoutes.append((firstStop, secondStop))
            groupedRoutes.append((secondStop, route.origin))
        }
        
        fetchNextRoute()
    }

    private func fetchNextRoute() {
        guard !groupedRoutes.isEmpty else { return }
        
        let nextGroup = groupedRoutes.removeFirst()
        let request = MKDirections.Request()
        
        request.source = nextGroup.startItem
        request.destination = nextGroup.endItem
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let mapRoute = response?.routes.first else { return }
            
            self.updateView(with: mapRoute)
            self.fetchNextRoute()
        }
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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Don't want to show a custom image if the annotation is the user's location.
            guard !annotation.isKind(of: MKUserLocation.self) else {
                return nil
            }

            let annotationIdentifier = "AnnotationIdentifier"

            var annotationView: MKAnnotationView?
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            }
            else {
                let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView = av
            }

            if let annotationView = annotationView {
                // Configure your annotation view here
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "FMF-map-pin")
            }

            return annotationView
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(overlay: overlay)

      renderer.strokeColor = .systemBlue
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
