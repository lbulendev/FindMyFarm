//
//  LocationManager.swift
//  FindWinery
//
//  Created by Larry Bulen on 10/3/21.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: CLLocationManager {
    var currentPlace: CLPlacemark?
    var currentRegion: MKCoordinateRegion?
    private let locationManager = CLLocationManager()

    override public init() {
        super.init()
        locationManager.delegate = self

        requestWhenInUseAuthorization()

        /*        if Bundle.main.backgroundModes.contains("location") {
            allowsBackgroundLocationUpdates = true
        }*/
    }
}

extension LocationManager: CLLocationManagerDelegate {
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
