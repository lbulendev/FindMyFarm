//
//  CarPlayTemplates.swift
//  FindWinery
//
//  Created by Larry Bulen on 4/16/22.
//

import Foundation
import CarPlay

extension CPMapTemplate {
    
    static func navigationMapTemplate(compatibleWith traitCollection: UITraitCollection,
                                      zoomInAction: @escaping () -> Void,
                                      zoomOutAction: @escaping () -> Void) -> CPMapTemplate {
        let mapTemplate = CPMapTemplate()
        
        let zoomInButton = CPMapButton { _ in
            zoomInAction()
        }
        zoomInButton.isHidden = false
        zoomInButton.isEnabled = true
        zoomInButton.image = UIImage(named: "cpZoomIn", in: Bundle.main, compatibleWith: traitCollection)
        
        let zoomOutButton = CPMapButton { _ in
            zoomOutAction()
        }
        zoomOutButton.isHidden = false
        zoomOutButton.isEnabled = true
        zoomOutButton.image = UIImage(named: "cpZoomOut", in: Bundle.main, compatibleWith: traitCollection)
        
        mapTemplate.mapButtons = [zoomInButton, zoomOutButton]
        mapTemplate.automaticallyHidesNavigationBar = false
        
        return mapTemplate
    }
}
