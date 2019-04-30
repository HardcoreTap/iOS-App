//
//  ButtonSupport.swift
//  TimeKillerApp
//
//  Created by Павел Анплеенко on 12/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

extension UIButton {
  
  func addShadow() {
    layer.shadowColor = UIColor(red: 232 / 255, green: 45 / 255, blue: 111 / 255, alpha: 0.5).cgColor
    layer.shadowOffset = CGSize(width: 2, height: 8)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 10.0
    layer.masksToBounds = false
  }
  
  func clearShadow(nameButton: UIButton) {
    layer.shadowColor = UIColor.clear.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0
    layer.shadowRadius = 0
    layer.masksToBounds = false
  }
  
}
