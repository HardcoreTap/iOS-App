//
//  SettingsCell.swift
//  HardcoreTap
//
//  Created by Павел Анплеенко on 14/01/2018.
//  Copyright © 2018 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var switchController: UISwitch!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
