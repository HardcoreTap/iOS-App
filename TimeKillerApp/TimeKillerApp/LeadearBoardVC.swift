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
            
            if let highscore = UserDefaults.standard.value(forKey: "highscore") {
                cell.nameCellLabel.text = UserDefaults.standard.value(forKey: "userNAME") as! String
                cell.pointsCellLabel.text = "\(highscore)"
                cell.backgroundColor = UIColor.gray
            } else {
                cell.nameCellLabel.text = "???"
                cell.pointsCellLabel.text = "0"
            }
            
        } else {
            
            //TODO: функция подгрузки топа
            cell.nameCellLabel.text = "\(indexPath.row + 1)"
            cell.pointsCellLabel.text = ""
        }
        
        return cell
        
    }
    
    
    //TODO:
    //Функция получения из firebase всех результатов и отсортировка их в массив в порядке убывания по highscore
    
}
