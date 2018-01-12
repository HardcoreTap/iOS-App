//
//  LeaderBoardCell.swift
//  TimeKillerApp
//
//  Created by Bogdan Bystritskiy on 11/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class LeaderBoardCell: UITableViewCell {
  
  @IBOutlet weak var nameCellLabel: UILabel!
  @IBOutlet weak var pointsCellLabel: UILabel!
  @IBOutlet weak var placeCellLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
