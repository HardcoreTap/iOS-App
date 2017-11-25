//
//  AppDelegate.swift
//  TimeKillerApp
//
//  Created by Bogdan Bystritskiy on 10/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit
import Firebase
import Siren


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaults = UserDefaults.standard


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //белый status bar
        UINavigationBar.appearance().tintColor = .white

        
        FirebaseApp.configure()

        
        //проверка на актуальность версии
        let siren = Siren.shared
        siren.alertType = .option
        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        siren.checkVersion(checkType: .daily)
        
        
        //увеличиваем счестчик запуска приложения
        if #available(iOS 10.3, *) {
            RateManager.incrementCount()
        } else {
            // Fallback on earlier versions
        }
        
        
        if isAppAlreadyLaunchedOnce() == true {

            //переходим на страницу с игрой
            let storyboard = UIStoryboard(name: "Main", bundle: nil )
            let jump = storyboard.instantiateViewController(withIdentifier: "tabBarController")
            window?.rootViewController = jump

        } else {

            //переходим на страницу с логином
            let storyboard = UIStoryboard(name: "Main",bundle: nil )
            let jump = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            window?.rootViewController = jump


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
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Siren.shared.checkVersion(checkType: .immediately)
    }
    
    
    
}

