//
//  AboutGameVC.swift
//  HardcoreTap
//
//  Created by Богдан Быстрицкий on 24/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class AboutGameVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
  }
  
}
