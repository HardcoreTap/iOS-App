//
//  AboutGameVC.swift
//  HardcoreTap
//
//  Created by Богдан Быстрицкий on 24/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class AboutGameVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var aboutGameLabel: UILabel!
	
	var sectionTitles = ["Tell about us", "Subscribe to githubs"]
	var sectionContent = [["Rate us on App Store", "Tell us your feedback"],
												["Sergey Dunaev", "Bystritskiy Bogdan", "Anpleenko Pavel"]]
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		aboutGameLabel.text = "Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков. Нажав на кнопку «Написать реферат», вы лично создаете."
  }
  
}


extension AboutGameVC {
	
	//изменения цвета и шрифта в заголовках секции
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as? UITableViewHeaderFooterView
		header?.textLabel?.font = UIFont(name: "OpenSans-Regular", size: 10)
		header?.textLabel?.textColor = UIColor.white
	}
	
	// MARK: - Table view data source
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
		IndexPath) {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0 :
				link(link: "https://www.apple.com/ru/ios/app-store/")
			case 1 :
				link(link: "https://www.apple.com/ru/ipad/")
			default:
				break
			}
		case 1:
			switch indexPath.row {
			case 0:
				link(link: "https://github.com/Dunaev")
				print("3")
			case 1:
				link(link: "https://github.com/bystritskiy")
				print("4")
			case 2:
				link(link: "https://github.com/allakin")
				print("5")
			default:
				break
			}
		default:
			break
		}
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	func link(link: String) {
		if let url = URL(string: link) {
			UIApplication.shared.open(url)
		}
	}
}

