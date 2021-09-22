//
//  FarmModel.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/11/21.
//

import Foundation

class FarmModel {
    let name: String?
    let location: (Double, Double)?

    init (name: String, location: (Double, Double)) {
        self.name = name
        self.location = location
    }
}
