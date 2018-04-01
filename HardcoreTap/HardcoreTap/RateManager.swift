//
//  RateManager.swift
//  HardcoreTap
//
//  Created by Bogdan Bystritskiy on 24/11/2017.
//  Copyright © 2017 Roman Zaynashev. All rights reserved.
//

import UIKit
import StoreKit

@available(iOS 10.3, *)

class RateManager {
  
  class func incrementCount() {
    let count = UserDefaults.standard.integer(forKey: "run_count")
    if count < 5 {
      UserDefaults.standard.set(count+1, forKey: "run_count")
      UserDefaults.standard.synchronize()
    }
  }
  
  class func showRatesController() {
    let count = UserDefaults.standard.integer(forKey: "run_count")
    if count == 5 {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        SKStoreReviewController.requestReview()
        UserDefaults.standard.set(count + 1, forKey: "run_count")
        UserDefaults.standard.synchronize()
      })
    }
  }
  
}
