//
//  FarmModel.swift
//  FindWinery
//
//  Created by Larry Bulen on 9/26/21.
//

import Foundation

class FarmModel {
    let crop: String?
    let name: String?
    let location: (Double, Double)?

    init (name: String, crop: String, location: (Double, Double)) {
        self.crop = crop
        self.name = name
        self.location = location
    }
}