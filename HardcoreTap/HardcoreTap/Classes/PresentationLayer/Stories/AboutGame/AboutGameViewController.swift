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
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    aboutGameLabel.text = "Лови ритм! Не убивай время просто так. Убивай время с пользой. HardcoreTap  — отличная тренировка внимательности, терпеливости, чувства ритма и упорства. Поднимись на вершину рейтинга таперов. Жми на экран с интервалом в одну секунду. Важна точность до сотых. С повышением уровня игра будет к тебе всё строже. Думаешь, это так просто? Попробуй."
  }
  
}

extension AboutGameViewController: UITableViewDelegate, UITableViewDataSource {
  
  //изменения цвета и шрифта в заголовках секции
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as? UITableViewHeaderFooterView
    header?.textLabel?.font = UIFont(name: "OpenSans-Regular", size: 10)
    header?.textLabel?.textColor = UIColor(hue: 0.24, saturation: 0.75, brightness: 0.89, alpha: 1.00)
    header?.backgroundView?.backgroundColor = UIColor(hue: 0.24, saturation: 0.75, brightness: 0.89, alpha: 0.1)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sectionContent[section].count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection
    section: Int) -> String? {
    return sectionTitles[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0 :
        self.performSegue(withIdentifier: "fromAboutGameToSettings", sender: self)
      default:
        break
      }
    case 1:
      switch indexPath.row {
      case 0 :
        link(link: "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)")
      case 1 :
        link(link: "https://github.com/bystritskiy/HardcoreTap")
      default:
        break
      }
    case 2:
      switch indexPath.row {
      case 0:
        link(link: "https://github.com/Dunaev")
      case 1:
        link(link: "https://github.com/bystritskiy")
      case 2:
        link(link: "https://github.com/allakin")
      default:
        break
      }
    default:
      break
    }
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
}
