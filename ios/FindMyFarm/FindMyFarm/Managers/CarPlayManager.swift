//
//  CarPlayManager.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/23/21.
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
    var carPlayMapViewController: CarPlayMapViewController? {
        if let mapViewController = carWindow?.rootViewController as? CarPlayMapViewController {
            return mapViewController
        }
        return nil
    }

    var locationManager: LocationManager?

    override public init() {
        super.init()
        locationManager = LocationManager()
    }
}

