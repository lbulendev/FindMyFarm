//
//  DataManager.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 10/3/21.
//

import Foundation

class DataManager: NSObject {
    let farms: [FarmModel] = [
        FarmModel(name: "Castello di Amorosa",
                  crop: "Grapes",
                  location: (38.5586, -122.5428),
                  size: "40 acres",
                  image: nil),
        FarmModel(name: "Stirling Winery",
                  crop: "Grapes",
                  location: (40.6685, -74.4881),
                  size: "30 acres",
                  image: nil)
    ]

    override public init() {
        super.init()
    }
}
