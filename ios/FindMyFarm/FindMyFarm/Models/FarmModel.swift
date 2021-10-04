//
//  FarmModel.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 9/11/21.
//

import UIKit

class FarmModel {
    let crop: String?
    let name: String?
    let location: (Double, Double)?
    let size: String?
    let image: UIImage?

    init (name: String?, crop: String?, location: (Double, Double)?, size: String?, image: UIImage?) {
        self.crop = crop
        self.name = name
        self.location = location
        self.size = size
        self.image = image
    }
}
