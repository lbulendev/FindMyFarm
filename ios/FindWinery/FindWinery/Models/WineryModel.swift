//
//  WineryModel.swift
//  FindWinery
//
//  Created by Larry Bulen on 4/15/22.
//

import UIKit

class WineryModel {
    let name: String?
    let location: (Double, Double)?
    let image: UIImage?

    init (name: String?, location: (Double, Double)?, image: UIImage?) {
        self.name = name
        self.location = location
        self.image = image
    }
}
