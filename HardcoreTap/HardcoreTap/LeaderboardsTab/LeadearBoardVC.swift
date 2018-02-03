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
  @IBOutlet weak var segmentedControlLeaderBoard: UISegmentedControl!
  
  var rootRef = Database.database().reference()
  var contentLeaderboardsNormal = [Content]()
  var contentLeaderboardsHardcore = [Content]()
  var countRowsInTable = Int()
  
  var nameUser : String?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let nameUser = UserDefaults.standard.value(forKey: "userNAME") as? String {
      self.nameUser = nameUser
    } else {
      self.nameUser = "Имя не определено"
    }
    
    //получение рекордов из обычного режима
    getNormalRecords()
    
    //получение рекордов из харкдор режима
    getHardcoreRecords()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    //        //показывам при загрузке экрана ту таблицу, какой режим игры был выбран
    //        if isHarcoreMode {
    //            segmentedControlLeaderBoard.selectedSegmentIndex = 1
    //        } else {
    //            segmentedControlLeaderBoard.selectedSegmentIndex = 0
    //        }
  }
  
  func getNormalRecords() {
    rootRef.child("leaderboards_normal").queryOrdered(byChild: "highscore").observe(.value, with: {(snapshot) in
      //очищаем
      self.contentLeaderboardsNormal = []
      
      for snap in snapshot.children.allObjects as! [DataSnapshot] {
        print(snapshot.children.allObjects)
        let name = snap.key
        
        if let rankedBy = snap.value as? [String : Any]  {
          self.contentLeaderboardsNormal.append(Content(sName: "\(name)", sPoints: rankedBy["highscore"] as! Int))
        }
      }
      self.tableView.reloadData()
      self.countRowsInTable = self.contentLeaderboardsNormal.count
      self.contentLeaderboardsNormal.reverse()
    })
  }
  
  func getHardcoreRecords() {
    rootRef.child("leaderboards_hadrcore").queryOrdered(byChild: "highscore").observe(.value, with: {(snapshot) in
      //очищаем
      self.contentLeaderboardsHardcore = []
      
      for snap in snapshot.children.allObjects as! [DataSnapshot] {
        let name = snap.key
        
        if let rankedBy = snap.value as? [String : Any]  {
          self.contentLeaderboardsHardcore.append(Content(sName: "\(name)", sPoints: rankedBy["highscore"] as! Int))
        }
      }
      self.tableView.reloadData()
      self.countRowsInTable = self.contentLeaderboardsHardcore.count
      self.contentLeaderboardsHardcore.reverse()
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.countRowsInTable
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderBoardCell
    
    //обнуляем сначала (защита от бага с переопределением)
    cell.placeCellLabel.text = nil
    cell.nameCellLabel.text = nil
    cell.pointsCellLabel.text = nil
    
    //для первых трек добавляем иконку короны
    if indexPath.row < 3 {
      cell.placeCellLabel.text = nil
      cell.placeCellLabel.text = ""
      cell.placeCellLabel.backgroundColor = UIColor(patternImage: UIImage(named: "iconLeader")!)
    } else {
      cell.placeCellLabel.backgroundColor = nil
      cell.placeCellLabel.text = nil
      cell.placeCellLabel.text = "\(indexPath.row + 1)"
    }
    
    if segmentedControlLeaderBoard.selectedSegmentIndex == 0 {
      
      cell.nameCellLabel.text = self.contentLeaderboardsNormal[indexPath.row].sName
      cell.pointsCellLabel.text = "\(self.contentLeaderboardsNormal[indexPath.row].sPoints!)"
      
      if self.contentLeaderboardsNormal[indexPath.row].sName! == nameUser  {
        cell.backgroundColor = nil
        cell.backgroundColor = UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100)
      } else {
        cell.backgroundColor = nil
      }
      
      return cell
      
    } else {
      
      cell.nameCellLabel.text = self.contentLeaderboardsHardcore[indexPath.row].sName
      cell.pointsCellLabel.text = "\(self.contentLeaderboardsHardcore[indexPath.row].sPoints!)"
      
      if self.contentLeaderboardsHardcore[indexPath.row].sName! == nameUser  {
        cell.backgroundColor = nil
        cell.backgroundColor = UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100)
      } else {
        cell.backgroundColor = nil
      }
      
      return cell
    }
  }
}



struct Content {
  var sName : String!
  var sPoints : Int!
  
  init(sName: String, sPoints: Int) {
    self.sName = sName
    self.sPoints = sPoints
  }
}
