//
//  CarPlaySceneDelegate.swift
//  FindWinery
//
//  Created by Larry Bulen on 10/6/21.
//

import CarPlay
import UIKit

class CarPlaySceneDelegate: NSObject {
    
    // MARK: UISceneDelegate
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if scene is CPTemplateApplicationScene, session.configuration.name == "TemplateSceneConfiguration" {
        } else if scene is CPTemplateApplicationDashboardScene, session.configuration.name == "DashboardSceneConfiguration" {
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        if scene.session.configuration.name == "TemplateSceneConfiguration" {
        } else if scene.session.configuration.name == "DashboardSceneConfiguration" {
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if scene.session.configuration.name == "TemplateSceneConfiguration" {
        } else if scene.session.configuration.name == "DashboardSceneConfiguration" {
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        if scene.session.configuration.name == "TemplateSceneConfiguration" {
        } else if scene.session.configuration.name == "DashboardSceneConfiguration" {
        }
    }
}

// MARK: CPTemplateApplicationSceneDelegate
extension CarPlaySceneDelegate: CPTemplateApplicationSceneDelegate {
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        TemplateManager.shared.interfaceController(interfaceController, didConnectWith: window)
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnect interfaceController: CPInterfaceController, from window: CPWindow) {
        TemplateManager.shared.interfaceController(interfaceController, didDisconnectWith: window)
    }
}
