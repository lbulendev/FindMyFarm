//
//  CLLocationDistance+Extension.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 10/24/21.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    func distance() -> String {
        let distance = self / 1609.34
        return "\(String(format:"%.2f", distance)) miles"
    }
}
