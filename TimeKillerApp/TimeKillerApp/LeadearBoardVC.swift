//
//  LeadearBoardVC.swift
//  TimeKillerApp
//
//  Created by Bogdan Bystritskiy on 11/11/2017.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LeadearBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var leaderboardDict : [String: String] = [String: String]()
    var rootRef = Database.database().reference()
    var leaderboardRef: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootRef.observe(.value, with: { (snapshot) in
            
            //получение всего словаря с данными всех игроков
            if let dict = snapshot.value as? [String:Any] {
                
                
                print(dict)
//                    let name = dict["username"] as? String
//                    print(name)
//                    let points = dict["highscore"] as? String
//                    print(points)
                
            }
            
        })

        
        
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
            cell.backgroundColor = UIColor.gray

            if let highscore = UserDefaults.standard.value(forKey: "highscore") {
                cell.nameCellLabel.text = UserDefaults.standard.value(forKey: "userNAME") as! String
                cell.pointsCellLabel.text = "\(highscore)"
            } else {
                cell.nameCellLabel.text = UserDefaults.standard.value(forKey: "userNAME") as! String
                cell.pointsCellLabel.text = "0"
            }
            
        } else {
            
            //TODO: функция подгрузки топа
            cell.nameCellLabel.text = "\(indexPath.row + 1):"
            cell.pointsCellLabel.text = ""
        }
        
        return cell
        
    }
    
    
    //TODO:
    //Функция получения из firebase всех результатов и отсортировка их в массив в порядке убывания по highscore
    
}
