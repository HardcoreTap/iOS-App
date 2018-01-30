//
//  HardcoreTap_UITests.swift
//  HardcoreTap UITests
//
//  Created by Malvin Rice on 14.01.2018.
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
    setupSnapshot(app)
    app.launch()
  
    snapshot("MainScreen")
    
    app.buttons["Начать игру"].tap()
    app.staticTexts["0"].tap()
    snapshot("MainWithTap")
    
    let tabBarsQuery = app.tabBars
    tabBarsQuery.buttons["Правила"].tap()
    snapshot("RulesScreen")
  }
  
}
