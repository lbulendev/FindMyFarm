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

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()

    var wineries = DataManager.shared.wineries
    let cellIdentifier = "UITableViewCell"

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
//            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            mapView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height * 0.66),
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.addSubview(tableView)
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        configureConstraints()
    }
}

extension MainViewController: MKMapViewDelegate {
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = wineries[indexPath.row].name
        guard let wineLocation = wineries[indexPath.row].location else {
            return cell
        }
        let annotation = MKPointAnnotation.init()
        annotation.coordinate = CLLocationCoordinate2D(latitude: wineLocation.0, longitude: wineLocation.1)
        annotation.title = wineries[indexPath.row].name
        mapView.addAnnotation(annotation)
        cell.detailTextLabel?.text = "(\(wineLocation.0), \(wineLocation.1))"
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
}

