//
//  HardcoreTapUITests.swift
//  HardcoreTapUITests
//
//  Created by Богдан Быстрицкий on 11/03/2018.
//  Copyright © 2018 Bogdan Bystritskiy. All rights reserved.
//

import XCTest

class HardcoreTap_UITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testExample() {
    let app = XCUIApplication()
    app.launchArguments = ["testMode"]
    app.launch()
    
    //LoginScreen
    snapshot("LoginScreen")
    app.textFields["Придумайте никнейм"].tap()
    app.textFields["Придумайте никнейм"].typeText("Быстрицкий")
    app.buttons["Играть"].tap()

    //MainScreen
    snapshot("MainScreen")
    
    //Gameplay
    app.buttons["Начать игру"].tap()
    app.staticTexts["0"].tap()
    snapshot("Gameplay")
    
    //LeaderboardsScreen
    let tabBarsQuery = app.tabBars
    tabBarsQuery.buttons["Рекорды"].tap()
    sleep(1)
    snapshot("LeaderboardsScreen")
    
    //RulesScreen
    tabBarsQuery.buttons["Правила"].tap()
    snapshot("RulesScreen")

    //AboutGameScreen
    app.buttons["Об игре / Разработчиках"].tap()
    snapshot("AboutGameScreen")
    app.navigationBars["Об игре"].buttons["Правила игры"].tap()
    
    //SettingsScreen
    let navigationBar = app.navigationBars["Правила игры"]
    navigationBar.buttons["Настройки"].tap()
    snapshot("SettingsScreen")
  }
  
}
