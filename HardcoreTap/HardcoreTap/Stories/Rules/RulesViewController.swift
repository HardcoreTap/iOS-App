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
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.view.backgroundColor = .clear
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
  }
  
  @IBAction func showSettingScreenAction(_ sender: Any) {
    performSegue(withIdentifier: "showSettingScreen", sender: self)
  }
  
}
