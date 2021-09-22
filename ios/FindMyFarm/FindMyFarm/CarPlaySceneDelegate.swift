//
//  CarPlaySceneDelegate.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/16/21.
//

import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?
    private let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?
    private var currentRegion: MKCoordinateRegion?

    var farmList: [FarmModel] = [
        FarmModel(name: "Napa, CA", location: (38.2975, -122.2869)),
        FarmModel(name: "Castello di Amorosa", location: (38.5586, -122.5428)),
        FarmModel(name: "Stirling Winery", location: (40.6685, -74.4881)),
        FarmModel(name: "Grand Canyon Village", location: (36.0544, -112.1401)),
        FarmModel(name: "Yellowstone NP", location: (44.4280, -110.5885)),
        FarmModel(name: "Yosemite NP", location: (37.8651, -119.5383))
    ]

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        print("templateApplicationScene(, didConnect interfaceController:, to window:")
        // Retain references to the interface controller and window for
        // the entire duration of the CarPlay session.
        self.interfaceController = interfaceController
        self.carWindow = window
        
        // Assign the window's root view controller to the view controller
        // that draws your map content.
        let origin = MKMapItem()
        let stops = [origin]
        let route = Route(origin: origin, stops: stops)

//        window.rootViewController = MapRenderingViewController(route: route)
        
        // Create a map template and set it as the root.
        let mapTemplate = self.makeMapTemplate()
        interfaceController.setRootTemplate(mapTemplate, animated: true,
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
//        let item1 = "Item1"
//        let item2 = "Item2"
//        let section1 = CPListSection.init(items: [item1, item2])
//        let sections: [CPListSection] = section1
//        let rootTemplate = CPListTemplate.init(title: "Farms", sections: sections)
//        return CPTemplate()
        let item = CPListItem.init(text: "Text", detailText: "Details")
        let image = UIImage.init()
        let rowItem = CPListImageRowItem.init(text: "test", images: [image])
        let section1 = CPListSection.init(items: [rowItem])
        let section2 = CPListSection.init(items: [item])
//        var item = CPListItem ("Text", "Details");
//        var rowItem = CPListImageRowItem ("test", new UIImage[] { });
//        var section = CPListSection (new CPListItem[] { rowItem, section });
        let rootTemplate = CPListTemplate.init(title: "Farms", sections: [section1, section2])
        return rootTemplate
    }

    func buildRoute() {
        let segment: RouteBuilder.Segment?
        if let currentLocation = currentPlace?.location {
          segment = .location(currentLocation)
        } else {
          segment = nil
        }

        let stopSegments: [RouteBuilder.Segment] = [
//            farmList[indexPath.row].name
            farmList[0].name
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
            let mapVC = MapViewController(route: route)
            let navigationController = UINavigationController()
            navigationController.pushViewController(mapVC, animated: true)

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

//      present(alertController, animated: true)
    }
}
