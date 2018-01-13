//
//  ButtonSupport.swift
//  TimeKillerApp
//
//  Created by Павел Анплеенко on 12/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class AddButtonShadow {
  
  func addShadow(nameButton: UIButton) {
    nameButton.layer.shadowColor = UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 0.5).cgColor
    nameButton.layer.shadowOffset = CGSize(width: 2, height: 8)
    nameButton.layer.shadowOpacity = 1.0
    nameButton.layer.shadowRadius = 10.0
    nameButton.layer.masksToBounds = false
  }
  
  func clearShadow(nameButton: UIButton) {
    nameButton.layer.shadowColor = UIColor.clear.cgColor
    nameButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    nameButton.layer.shadowOpacity = 0
    nameButton.layer.shadowRadius = 0
    nameButton.layer.masksToBounds = false
  }
  
}
