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
import NVActivityIndicatorView

class LeadearBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControlLeaderBoard: UISegmentedControl!
  @IBOutlet weak var loadIndicator: NVActivityIndicatorView!

  var rootRef = Database.database().reference()
  
  var content = [Content]()

  var contentLeaderboardsNormal = [Content]()
  var contentLeaderboardsHardcore = [Content]()
  
  var nameUser : String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    
    nameUser = (UserDefaults.standard.value(forKey: "userNAME") as! String)
    
    loadIndicator.type = .lineScale
    loadIndicator.color = UIColor(named: "yellowishGreen")!
    loadIndicator.startAnimating()
    
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
  
  
  @IBAction func switchSegmentedDidTapped(_ sender: Any) {
    switch segmentedControlLeaderBoard.selectedSegmentIndex
    {
    case 0:
      self.content = self.contentLeaderboardsNormal
      self.tableView.reloadData()
    case 1:
      self.content = self.contentLeaderboardsHardcore
      self.tableView.reloadData()
    default:
      break;
    }
  }
  
  func getNormalRecords() {
    rootRef.child("leaderboards_normal").queryOrdered(byChild: "highscore").observe(.value, with: {(snapshot) in
      
      self.contentLeaderboardsNormal = []
      
      for snap in snapshot.children.allObjects as! [DataSnapshot] {
        let name = snap.key
        
        if let rankedBy = snap.value as? [String : Any]  {
          self.contentLeaderboardsNormal.append(Content(sName: "\(name)", sPoints: rankedBy["highscore"] as! Int))
        }
      }
      self.loadIndicator.stopAnimating()
      self.contentLeaderboardsNormal.reverse()
      self.content = self.contentLeaderboardsNormal
      self.tableView.reloadData()
      })
  }
  
  func getHardcoreRecords() {
    rootRef.child("leaderboards_hardcore").queryOrdered(byChild: "highscore").observe(.value, with: {(snapshot) in

      self.contentLeaderboardsHardcore = []
      
      for snap in snapshot.children.allObjects as! [DataSnapshot] {
        let name = snap.key
        
        if let rankedBy = snap.value as? [String : Any]  {
          self.contentLeaderboardsHardcore.append(Content(sName: "\(name)", sPoints: rankedBy["highscore"] as! Int))
        }
      }
      self.contentLeaderboardsHardcore.reverse()
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.content.count-1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderBoardCell
    
    //обнуляем сначала (защита от бага с переопределением)
    cell.placeCellLabel.text = nil
    cell.nameCellLabel.text = nil
    cell.pointsCellLabel.text = nil
    
    cell.nameCellLabel.text = self.content[indexPath.row].sName
    cell.pointsCellLabel.text = "\(self.content[indexPath.row].sPoints!)"
    
    if self.content[indexPath.row].sName! == nameUser  {
      cell.backgroundColor = nil
      cell.backgroundColor = UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100)
    } else {
      cell.backgroundColor = nil
    }
    
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
    return cell
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
