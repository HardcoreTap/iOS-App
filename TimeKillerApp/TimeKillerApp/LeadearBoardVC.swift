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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromFirebase()


        tableView.delegate = self
        tableView.dataSource = self

        
    }
    

    func getDataFromFirebase() {
        rootRef.child("leaderboards").queryOrdered(byChild: "highscore").observe(.value, with: {(snapshot) in
            
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
        return self.contentLeaderboards.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderBoardCell
        
        
//        print(self.contentLeaderboards[indexPath.row].sName)
//        UserDefaults.standard.synchronize()

//        if indexPath.row == 10 {
//            cell.backgroundColor = UIColor.gray
//
//            if let highscore = UserDefaults.standard.value(forKey: "highscore") {
//                cell.nameCellLabel.text = (UserDefaults.standard.value(forKey: "userNAME") as! String)
//                cell.pointsCellLabel.text = "\(highscore)"
//            } else {
//                cell.nameCellLabel.text = (UserDefaults.standard.value(forKey: "userNAME") as! String)
//                cell.pointsCellLabel.text = "0"
//            }
//
//        } else {
        
        cell.nameCellLabel.text = self.contentLeaderboards[indexPath.row].sName
        cell.pointsCellLabel.text = "\(self.contentLeaderboards[indexPath.row].sPoints!)"
        
//        }

        
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
