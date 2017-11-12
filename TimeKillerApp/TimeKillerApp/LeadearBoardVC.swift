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
    
    var rootRef = Database.database().reference()
    var contentLeaderboards : [content] = []
    var nameUser : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)

        nameUser = UserDefaults.standard.value(forKey: "userNAME") as! String
        
        getDataFromFirebase()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    

    func getDataFromFirebase() {
        rootRef.child("leaderboards").queryOrdered(byChild: "highscore").observe(.value, with: {(snapshot) in
        
            //очищаем на всякий случай
            self.contentLeaderboards = []
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                
                let name = snap.key
                
                if let rankedBy = snap.value as? [String : Any]  {
                    self.contentLeaderboards.append(content(sName: "\(name)", sPoints: rankedBy["highscore"] as! Int))
                    self.tableView.reloadData()
                }
            }
            self.contentLeaderboards.reverse()
        })
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentLeaderboards.count-1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderBoardCell
        
        cell.nameCellLabel.text = self.contentLeaderboards[indexPath.row].sName
        cell.pointsCellLabel.text = "\(self.contentLeaderboards[indexPath.row].sPoints!)"
        
        if self.contentLeaderboards[indexPath.row].sName! == nameUser  {
            cell.backgroundColor = UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100)
        }
        
        //для первых трек добавляем иконку короны
        if indexPath.row < 3 {
            cell.placeCellLabel.text = ""
            cell.placeCellLabel.backgroundColor = UIColor(patternImage: UIImage(named: "iconLeader")!)
        } else {
            cell.placeCellLabel.text = "\(indexPath.row + 1)"

        }

        return cell
        
    }
    

    
}



struct content {
    var sName : String!
    var sPoints : Int!
    
    init(sName: String, sPoints: Int) {
        self.sName = sName
        self.sPoints = sPoints
    }
}
