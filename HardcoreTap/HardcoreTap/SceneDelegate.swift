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
        let window = UIWindow(frame: UIScreen.main.bounds)
        let hostingController = UIHostingController(rootView: LoginView())
        window.rootViewController = hostingController
        self.window = window
        window.makeKeyAndVisible()
    }
    
}
