//
//  UIViewControllerExtensions.swift
//  HardcoreTap
//
//  Created by Богдан Быстрицкий on 07/07/2018.
//  Copyright © 2018 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func link(link: String) {
    if let url = URL(string: link) {
      UIApplication.shared.open(url)
    }
  }
  
  func makeTransparentNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.view.backgroundColor = .clear
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
  }
}
