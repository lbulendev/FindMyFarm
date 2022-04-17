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
    static let instance: LocationManager = LocationManager()

    var currentPlace: CLPlacemark?
    var currentRegion: MKCoordinateRegion?

    fileprivate let manager = CLLocationManager()
    fileprivate var localizationAlreadyRequested: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "localizationAlreadyRequested")
        }
        set(requested) {
            UserDefaults.standard.set(requested, forKey: "localizationAlreadyRequested")
        }
    }

    override public init() {
        super.init()
        manager.delegate = self

        requestWhenInUseAuthorization()

        /*        if Bundle.main.backgroundModes.contains("location") {
            allowsBackgroundLocationUpdates = true
        }*/
    }

    func authorized(forceAlert: Bool = true, completion: (() -> Void)?) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            if let completion = completion {
                completion()
            }
        case .notDetermined:
            if forceAlert || !localizationAlreadyRequested {
                self.manager.requestWhenInUseAuthorization()
            }
        case .restricted, .denied:
            if forceAlert {
                self.manager.requestWhenInUseAuthorization()
            }
        @unknown default:
            break
        }
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
