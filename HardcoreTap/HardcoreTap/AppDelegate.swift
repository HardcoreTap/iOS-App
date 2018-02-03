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
//import GoogleMobileAds
import Fabric
import Crashlytics

var isHarcoreMode : Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var defaults = UserDefaults.standard
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    //Косметика navigationBar
    UINavigationBar.appearance().tintColor = .white
    
    //Конфигурация Fabric
    Fabric.with([Crashlytics.self])

    //Конфигурация Firebase
    FirebaseApp.configure()
    
    //Конфигурация Google AdMod
//    GADMobileAds.configure(withApplicationID: PrivateInfo.admodKey)
    
    //Проверка на актуальность версии
    checkVersionApp()
    
    //Проверка на первых вход
    checkOnFirstLaunchApp()
    
    //Увеличиваем счестчик запуска приложения
    RateManager.incrementCount()

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
  
  func checkOnFirstLaunchApp() {
    if isAppAlreadyLaunchedOnce() == true {
      //переходим на страницу с игрой
      let storyboard = UIStoryboard(name: "Main",bundle: nil)
      let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController")
      window?.rootViewController = tabBar
    } else {
      //переходим на страницу с логином
      let storyboard = UIStoryboard(name: "Main",bundle: nil )
      let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
      window?.rootViewController = loginVC
    }
  }
  
  func checkVersionApp() {
    let siren = Siren.shared
    siren.alertType = .option
    siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
    siren.checkVersion(checkType: .daily)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    Siren.shared.checkVersion(checkType: .immediately)
  }
}
