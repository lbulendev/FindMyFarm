//
//  TimeInterval+Extension.swift
//  FindMyFarm
//
//  Created by Larry Bulen on 10/24/21.
//

import Foundation

extension TimeInterval {
    func timeToTravel() -> String {
        let hours = floor(self / 60.0 / 60.0)
        let minutes = floor(floor(self - (hours * 60.0 * 60.0)) / 60.0)
        return "\(String(format:"%.0f", hours)):\(String(format:"%.0f", minutes)) hours"
    }
}
