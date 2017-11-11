//
//  LeadearBoardVC.swift
//  TimeKillerApp
//
//  Created by Bogdan Bystritskiy on 11/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit

class LeadearBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderBoardCell
        
        UserDefaults.standard.synchronize()

        if indexPath.row == 10 {
            cell.textLabel?.tintColor = UIColor.brown
            
            if let highscore = UserDefaults.standard.value(forKey: "highscore") {
                cell.textLabel?.text = "Ваш результат: \(highscore)"
            } else {
                cell.textLabel?.text = "Ваш результат: ???"
            }
            
        } else {
            
            //TODO: функция подгрузки топа
            cell.textLabel?.text = "Топ \(indexPath.row + 1): "
        }
        
        return cell
        
    }
    
    
    //TODO:
    //Функция получения из firebase всех результатов и отсортировка их в массив в порядке убывания по highscore
    
}
