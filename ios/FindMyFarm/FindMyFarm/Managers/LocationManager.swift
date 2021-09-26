//
//  LocationManager.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/25/21.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {

    override public init() {
        super.init()

        requestWhenInUseAuthorization()

        /*        if Bundle.main.backgroundModes.contains("location") {
            allowsBackgroundLocationUpdates = true
        }*/
    }
}
