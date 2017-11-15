//
//  AppDelegate.swift
//  TimeKillerApp
//
//  Created by Bogdan Bystritskiy on 10/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaults = UserDefaults.standard


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //белый status bar
        UIApplication.shared.statusBarStyle = .lightContent

        
        FirebaseApp.configure()

        //для отладки: что хранится в userdefaults
//        print("UserDefaults: ================================")
//        print(UserDefaults.standard.dictionaryRepresentation())
        
        
        
        // MARK: Проверка на первый запуск приложения
        //       Закомментить, чтобы отключить для тестов
   
        if isAppAlreadyLaunchedOnce() == true {

            //переходим на страницу с игрой
            let storyboard = UIStoryboard(name: "Main", bundle: nil )
            let jump = storyboard.instantiateViewController(withIdentifier: "tabBarController")
            window?.rootViewController = jump
            UserDefaults.standard.synchronize()

        } else {

            //переходим на страницу с логином
            let storyboard = UIStoryboard(name: "Main",bundle: nil )
            let jump = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            window?.rootViewController = jump
            UserDefaults.standard.synchronize()


        }
        
        return true
    }
    


    

    func isAppAlreadyLaunchedOnce() -> Bool {
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
        
    }
    
    
    
}

