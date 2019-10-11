//
//  SceneDelegate.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 11.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let hostingController = UIHostingController(rootView: NavigationView { LoginView() })
            window.rootViewController = hostingController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
}
