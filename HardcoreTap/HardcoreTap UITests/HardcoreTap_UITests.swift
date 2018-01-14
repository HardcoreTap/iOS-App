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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    
    let app = XCUIApplication()
    setupSnapshot(app)
    app.launch()
    
    snapshot("1")
    
  }
  
}
