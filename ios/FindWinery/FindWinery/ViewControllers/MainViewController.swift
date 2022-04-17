//
//  MainViewController.swift
//  FindWinery
//
//  Created by Larry Bulen on 4/15/22.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
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
}

