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
import SwiftMessages
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
//import GoogleMobileAds

let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let appID = "1334647124"

var isHarcoreMode: Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var defaults = UserDefaults.standard
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    resetStateIfUITesting()
    
    IQKeyboardManager.shared.enable = true

    //Косметика navigationBar
    UINavigationBar.appearance().tintColor = .white
    
    //Конфигурация Fabric
    Fabric.with([Crashlytics.self])
    
    //Конфигурация Firebase
    FirebaseApp.configure()
    
    GADMobileAds.configure(withApplicationID: PrivateInfo.admobAppID)

    //Проверка на актуальность версии
    checkVersionApp()

    //Увеличиваем счестчик запуска приложения
    RateManager.incrementCount()
    
    //если юзер уже авторизован отправляем на домашнюю страницу
    if let userNAME = UserDefaults.standard.value(forKey: "userNAME") as? String {
      if userNAME != "" {
        login()
      }
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
  
  //переходим на страницу с игрой
  func login() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil )
    let jump = storyboard.instantiateViewController(withIdentifier: "tabBarController")
    window?.rootViewController = jump
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
  
  private func resetStateIfUITesting() {
    if ProcessInfo.processInfo.arguments.contains("testMode") {
      let defaults = UserDefaults.standard
      let dictionary = defaults.dictionaryRepresentation()
      dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
      }
      defaults.synchronize()
    }
  }
  
  func simpleMsg(title: String, text: String, colorBg: UIColor, colorText: UIColor, iconText: String) {
    let view = MessageView.viewFromNib(layout: .centeredView)
    view.configureTheme(.warning)
    view.configureContent(title: title, body: text, iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
    view.button?.isHidden = true
    view.configureDropShadow()
    view.configureTheme(backgroundColor: colorBg, foregroundColor: colorText)
    view.backgroundView.layer.cornerRadius = 10
    var config = SwiftMessages.defaultConfig
    config.presentationStyle = .bottom
    config.duration = .seconds(seconds: 2)
    SwiftMessages.show(config: config, view: view)
  }
  
}
