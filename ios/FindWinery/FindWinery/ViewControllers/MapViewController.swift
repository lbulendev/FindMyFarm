//
//  MapViewController.swift
//  FindWinery
//
//  Created by Larry Bulen on 4/15/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isScrollEnabled = true
        mapView.isUserInteractionEnabled = true
        mapView.isZoomEnabled = true
//        mapView.showsUserLocation = true
        return mapView
    }()

    required init() {
        super.init(nibName: nil, bundle: nil)
    }

    required override init(nibName: String?, bundle: Bundle?) {
        fatalError("init(nibName: String?, bundle: Bundle?) has no been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.delegate = self
        view.addSubview(mapView)
        configureConstraints()
    }

    // MARK: MapView Actions
    func getZoom() -> Double {
        var angleCamera = mapView.camera.heading
        if angleCamera > 270 {
            angleCamera = 360 - angleCamera
        } else if angleCamera > 90 {
            angleCamera = fabs(angleCamera - 180)
        }
        let angleRad = Double.pi * angleCamera / 180
        let width = Double(self.view.frame.size.width)
        let height = Double(self.view.frame.size.height)
        let heightOffset : Double = 20
        let spanStraight = width * mapView.region.span.longitudeDelta / (width * cos(angleRad) + (height - heightOffset) * sin(angleRad))
        return log2(360 * ((width / 256) / spanStraight)) + 1;
    }

    func zoomIn() {
        let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta * 0.7,
                                    longitudeDelta: mapView.region.span.longitudeDelta * 0.7)
        let region = MKCoordinateRegion(center: mapView.region.center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func zoomOut() {
        let zoom = getZoom() // to get the value of zoom of your map.
        if zoom > 3.5{ // **here i have used the condition that avoid the mapview to zoom less then 3.5 to avoid crash.**
            let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 0.7,
                                        longitudeDelta: mapView.region.span.longitudeDelta / 0.7)
            let region = MKCoordinateRegion(center: mapView.region.center, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
}
