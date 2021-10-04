//
//  CarPlaySceneDelegate.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/16/21.
//

import CarPlay
import CoreLocation

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?
    lazy var carPlayManager: CarPlayManager = CarPlayManager()
    private var currentPlace: CLPlacemark?
    private var currentRegion: MKCoordinateRegion?

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        print("templateApplicationScene(, didConnect interfaceController:, to window:")
        // Retain references to the interface controller and window for
        // the entire duration of the CarPlay session.
        self.interfaceController = interfaceController
        self.carWindow = window

        // Assign the window's root view controller to the view controller
        // that draws your list your farm content.

        // Create a template and set it as the root.
        let listVc = CarPlayListViewController()
        window.rootViewController = listVc
        let rootTemplate = self.makeRootTemplate()
        interfaceController.setRootTemplate(rootTemplate, animated: true,
                                            completion: nil)
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        print("templateApplicationScene(, didConnect interfaceController:")
        // Store a reference to the interface controller so
        // you can add and remove templates as the user
        // interacts with your app.
        self.interfaceController = interfaceController
        
        // Create a template and set it as the root.
        let rootTemplate = self.makeRootTemplate()
        interfaceController.setRootTemplate(rootTemplate, animated: true,
                                            completion: nil)
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnect interfaceController: CPInterfaceController, from window: CPWindow) {
        print("templateApplicationScene(, didDisconnect interfaceController:, from window:")
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
        print("templateApplicationScene(, didDisconnect interfaceController:")
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didSelect navigationAlert: CPNavigationAlert) {
        print("templateApplicationScene(, didSelect navigationAlert:")
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didSelect maneuver: CPManeuver) {
        print("templateApplicationScene(, didSelect maneuver:")
    }

    func makeMapTemplate() -> CPTemplate {
        let mapTemplate = CPMapTemplate.init()
        return mapTemplate
        //        return CPTemplate()
    }

    func makeRootTemplate() -> CPTemplate {
        var itemArray: [CPListItem] = []
        guard let farms = carPlayManager.dataManager?.farms else { return CPListTemplate.init(title: nil, sections: []) }
        for farm in farms {
            if let name = farm.name,
               let size = farm.size,
               let crop = farm.crop {
            itemArray.append(CPListItem.init(text: name, detailText: "Crop: \(crop), Size: \(size)", image: farm.image))
            }
        }
        let section = CPListSection.init(items: itemArray, header: nil, sectionIndexTitle: nil)
        let rootTemplate = CPListTemplate.init(title: nil, sections: [section])
        carPlayManager.locationManager?.delegate = self
        rootTemplate.delegate = self
        return rootTemplate
    }

    func buildRoute(index: Int) {
        let segment: RouteBuilder.Segment?
        let farmList = carPlayManager.dataManager?.farms ?? []
        if let currentLocation = carPlayManager.locationManager?.location {
            segment = .location(currentLocation)
        } else {
            segment = nil
        }

        let stopSegments: [RouteBuilder.Segment] = [
            farmList[index].name
        ]
            .compactMap { contents in
                if let value = contents {
                    return .text(value)
                } else {
                    return nil
                }
            }
        guard
            let originSegment = segment,
            !stopSegments.isEmpty
        else {
            self.presentAlert(message: "Please select an origin and at least 1 stop.")
            return
        }

        RouteBuilder.buildRoute(
            origin: originSegment,
            stops: stopSegments,
            within: currentRegion
        ) { result in

            switch result {
            case .success(let route):
                let mapVC = CarPlayMapViewController()
                mapVC.route = route
                self.carWindow?.rootViewController = mapVC
                let mapTemplate = self.makeMapTemplate()
                self.interfaceController?.pushTemplate(mapTemplate, animated: true, completion: nil)

            case .failure(let error):
                let errorMessage: String

                switch error {
                case .invalidSegment(let reason):
                    errorMessage = "There was an error with: \(reason)."
                }

                self.presentAlert(message: errorMessage)
            }
        }
    }

    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    }
}

extension CarPlaySceneDelegate: CPListTemplateDelegate {
    func listTemplate(_ listTemplate: CPListTemplate, didSelect item: CPListItem, completionHandler: @escaping () -> Void) {
        print("**** didSelect => name: \(item.text)")
        let farmList = carPlayManager.dataManager?.farms ?? []
        if let index = farmList.firstIndex(where: { $0.name == item.text }) {
            buildRoute(index: index)
        }
    }
}

extension CarPlaySceneDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            guard let firstPlace = places?.first else { return }
            self.currentPlace = firstPlace
            print("currentPlace: \(self.currentPlace)")
        }
        let commonDelta: CLLocationDegrees = 25 / 111 // 1/111 = 1 latitude km
        let span = MKCoordinateSpan(latitudeDelta: commonDelta, longitudeDelta: commonDelta)
        let region = MKCoordinateRegion(center: firstLocation.coordinate, span: span)

        currentRegion = region
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Swift.Error) {
        print("error:: \(error)")
    }
}

