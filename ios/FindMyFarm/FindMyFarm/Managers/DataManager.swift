//
//  DataManager.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 10/3/21.
//

import Foundation
import MapKit

class DataManager: NSObject {
    var routes: [MKRoute] = []

    let farms: [FarmModel] = [
        FarmModel(name: "Castello di Amorosa",
                  crop: "Grapes",
                  location: (38.5586, -122.5428),
                  size: "40 acres",
                  image: nil,
                  routes: nil),
        FarmModel(name: "Sterling Winery",
                  crop: "Grapes",
                  location: (38.5724076, -122.5552601),
                  size: "30 acres",
                  image: nil,
                  routes: nil),
        FarmModel(name: "37.7749",
                  crop: "Crab",
                  location: (37.7749, -122.4194),
                  size: "120 acres",
                  image: nil,
                  routes: nil),
        FarmModel(name: "Des Moines, IA",
                  crop: "Corn",
                  location: (41.5868, -93.6250),
                  size: "50 acres",
                  image: nil,
                  routes: nil)
    ]

    override public init() {
        super.init()
    }
}
