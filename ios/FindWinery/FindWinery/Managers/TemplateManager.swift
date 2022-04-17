//
//  TemplateManager.swift
//  FindWinery
//
//  Created by Larry Bulen on 4/15/22.
//

import Foundation
import CarPlay

class TemplateManager: NSObject {
    static let shared = TemplateManager()

    private(set) var baseMapTemplate: CPMapTemplate?
    private var carplayInterfaceController: CPInterfaceController?
    private var carWindow: UIWindow?
    private let locationManager = LocationManager()
    private let mapViewController = MapViewController()
    private var sessionConfiguration: CPSessionConfiguration!

    override init() {
        super.init()
        sessionConfiguration = CPSessionConfiguration(delegate: self)
    }
}

extension TemplateManager: CPInterfaceControllerDelegate {
    func interfaceController(_ interfaceController: CPInterfaceController, didConnectWith window: CPWindow) {
        carplayInterfaceController = interfaceController
        carplayInterfaceController!.delegate = self

        window.rootViewController = mapViewController

        carWindow = window
        locationManager.delegate = self
//        locationManager.authorized(forceAlert: false, completion: {
//
//        })

        let mapTemplate = CPMapTemplate.navigationMapTemplate(compatibleWith: mapViewController.traitCollection, zoomInAction: {
            self.mapViewController.zoomIn()
        }, zoomOutAction: {
            self.mapViewController.zoomOut()
        })

        mapTemplate.mapDelegate = self

        baseMapTemplate = mapTemplate

        interfaceController.setRootTemplate(mapTemplate, animated: true) { (_, _) in }
        
//        GLitePreferences.shared.selectedField.asObservable()
//            .subscribe(onNext: { [weak self] field in
//                self?.installBarButtons(selectedField: field)
//        })
    }

    func interfaceController(_ interfaceController: CPInterfaceController, didDisconnectWith window: CPWindow) {
        carplayInterfaceController = nil
        carWindow?.isHidden = true
    }
}

extension TemplateManager: CPSessionConfigurationDelegate {
}

extension TemplateManager: CLLocationManagerDelegate {
}

extension TemplateManager: CPMapTemplateDelegate {
}
