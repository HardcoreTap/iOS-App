//
//  TabBarVC.swift
//  TimeKillerApp
//
//  Created by Bogdan Bystritskiy on 11/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
  
  @IBOutlet weak var myTabBar: UITabBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //        делаем прозрачный tabbar
    myTabBar.backgroundColor = UIColor.clear
    myTabBar.backgroundImage = UIImage()
    myTabBar.shadowImage = UIImage()
  }
  
}
