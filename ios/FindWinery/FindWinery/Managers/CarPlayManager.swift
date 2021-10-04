//
//  CarPlayManager.swift
//  FindWinery
//
//  Created by Larry Bulen on 10/3/21.
//

import UIKit

enum CarPlayActivity: Int {
    case browsing
    case panningInBrowsingMode
    case previewing
    case navigating
}

class CarPlayManager: NSObject {
    var carWindow: UIWindow?
    var mapViewController: GoogleMapViewController? {
        if let mapViewController = carWindow?.rootViewController as? GoogleMapViewController {
            return mapViewController
        }
        return nil
    }
//    var carPlayMapViewController: CarPlayMapViewController? {
//        if let mapViewController = carWindow?.rootViewController as? CarPlayMapViewController {
//            return mapViewController
//        }
//        return nil
//    }

    var dataManager: DataManager?
    var locationManager: LocationManager?

    override public init() {
        super.init()
        dataManager = DataManager()
        locationManager = LocationManager()
    }
}
