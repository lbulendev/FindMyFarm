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
    var route: MKRoute? = nil
    var correctedRoute: MKRoute? = nil
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

    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.50),

            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(mapView)
        view.addSubview(tableView)

        configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init?(route: MKRoute) {
        self.route = route
        for step in route.steps {
            if step.instructions.count > 0 {
//                correctedRoute.steps.append(step)
                print("**** step.instructions.count > 0: \(step.instructions.count > 0)")
            } else {
                print("**** step.instructions.count <= 0: \(step.instructions.count > 0)")

            }
        }
        super.init(nibName: nil, bundle: nil)
    }
}

extension TurnNavigationViewController: MKMapViewDelegate {
}

extension TurnNavigationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return correctedRoute?.steps.count ?? 0
        return route?.steps.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        cell.textLabel?.text = route?.steps[indexPath.row].instructions
        return cell
    }
}

extension TurnNavigationViewController: UITableViewDelegate {
}

