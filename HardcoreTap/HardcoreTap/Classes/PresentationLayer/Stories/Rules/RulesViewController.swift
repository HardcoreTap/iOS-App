//
//  RulesVC.swift
//  TimeKillerApp
//
//  Created by Bogdan Bystritskiy on 11/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func showSettingScreenAction(_ sender: Any) {
    performSegue(withIdentifier: "showSettingScreen", sender: self)
  }
  
}
