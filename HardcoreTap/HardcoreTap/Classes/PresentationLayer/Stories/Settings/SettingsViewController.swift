//
//  SettingsVC.swift
//  HardcoreTap
//
//  Created by Богдан Быстрицкий on 24/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
  
  @IBOutlet weak var heighOfDisableAdStackView: NSLayoutConstraint!
  @IBOutlet weak var disableAdButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  var titleSetting = ["Фоновый звук"]
  var bgSound = true
  
  let userDefaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    disableAdButton.addShadow()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    //		userDefaults.set(bgSound, forKey: "bgSound")
  }
  
  @IBAction func disableAdButtonDidTapped(_ sender: Any) {
    
  }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleSetting.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsCell
    cell.titleLabel.text = titleSetting[indexPath.row]
    let switchView = UISwitch(frame: .zero)
    switchView.setOn(userDefaults.bool(forKey: "bgSound"), animated: true)
    switchView.onTintColor = UIColor(red: 223 / 255, green: 15 / 255, blue: 92 / 255, alpha: 1)
    switchView.tag = indexPath.row
    switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    cell.accessoryView = switchView
    return cell
  }
  
  @objc func switchChanged(_ sender: UISwitch!) {
    if sender.isOn {
      bgSound = true
      userDefaults.set(bgSound, forKey: "bgSound")
    } else {
      bgSound = false
      userDefaults.set(bgSound, forKey: "bgSound")
    }
  }
  
}
