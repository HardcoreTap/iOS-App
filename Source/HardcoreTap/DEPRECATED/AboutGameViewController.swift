//
//  AboutGameVC.swift
//  HardcoreTap
//
//  Created by Богдан Быстрицкий on 24/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class AboutGameViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var aboutGameLabel: UILabel!
  
  let appID = "1334647124"

  var sectionTitles = ["Поддержите разработчиков", "Расскажите о нас", "Мы на GitHub"]
  var sectionContent = [
    ["Отключить рекламу в приложении"],
    ["Оцените приложение на App Store", "Репозиторий на GitHub"],
    ["Dunaev Sergey", "Bystritskiy Bogdan", "Anpleenko Pavel"]
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    aboutGameLabel.text = "Лови ритм! Не убивай время просто так. Убивай время с пользой. HardcoreTap  — отличная тренировка внимательности, терпеливости, чувства ритма и упорства. Поднимись на вершину рейтинга таперов. Жми на экран с интервалом в одну секунду. Важна точность до сотых. С повышением уровня игра будет к тебе всё строже. Думаешь, это так просто? Попробуй."
  }
  
}
