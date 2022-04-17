//
//  DataManager.swift
//  FindWinery
//
//  Created by Larry Bulen on 10/3/21.
//

import Foundation

class DataManager: NSObject {
    static let shared = DataManager()

    let wineries: [WineryModel] = [
        WineryModel(name: "Castello di Amorosa",
                  location: (38.5586, -122.5428),
                  image: nil),
        WineryModel(name: "Sterling Vineyards",
                  location: (40.6685, -74.4881),
                  image: nil)
    ]

    override public init() {
        super.init()
    }
}
