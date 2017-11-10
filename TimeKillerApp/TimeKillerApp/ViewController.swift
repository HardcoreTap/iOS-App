//
//  ViewController.swift
//
//  Created by Bogdan Bystritskiy on 10/11/17.
//  Copyright © 2017 Bogdan Bystritskiy. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class ViewController: UIViewController {
    
    var count: Int = 0
    var seconds: Int = 0
    var timer: Timer?
    var uid: String = ""
    let username = mainInstance.name
    
    var highScore: Int = 0
    
    var rootRef = Database.database().reference()
    var scoreRef: DatabaseReference!
    

    @IBOutlet weak var switchModeGame: UISwitch!
    @IBOutlet weak var hardcoreLabel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var mainTapButton: UIButton! //клик в игре - который самый главный


    
    
    //MARK : viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //скрываем все лишнее, и ждем нажатия кнопки "Начать игру"
        self.scoreLabel.isHidden = true

        
        // Firebase reference
        scoreRef = rootRef.child("High Score")
        
    }
    


    
    @IBAction func startGameButtonDidTapped(_ sender: Any) {
        
        self.mainTapButton.isHidden = false
        self.highScoreLabel.isHidden = false
        self.scoreLabel.isHidden = false
        
        self.startGameButton.isHidden = true
        self.hardcoreLabel.isHidden = true
        self.switchModeGame.isHidden = true
        
        self.setupGame()
        
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        count += 1
        scoreLabel.text = "Очки: \(count)"
    }
    
    
    func setupGame() {
        
        seconds = 5
        count = 0
        
        timerLabel.text = "\(seconds)"
        scoreLabel.text = "Очки: \(count)"
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.subtractTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func subtractTime() {
        seconds -= 1
        timerLabel.text = "\(seconds)"
        
        if seconds == 0 {
            timer?.invalidate()
            
            
             let itemRef = self.scoreRef.childByAutoId()

             let scoreItem = [
                "username": self.username,
                "highscore": self.highScore
                ] as [String : Any]

            print(self.username, "ЧЧЧЧЧЧЧЧ", self.highScore)
            print(self.count)
            print(self.uid)

            itemRef.setValue(scoreItem)
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("Начать заново") {
                //рестарт игры
                self.setupGame()
            }
            
            alertView.addButton("Таблица лидеров") {
                
                //переходим на страницу с лидербоард
                self.tabBarController?.selectedIndex = 1

                
                
            }
            
            alertView.showSuccess("Вы крут!", subTitle: "Вы набрали \(count). очков")
            
            
            
        }
        
    }

    
    
}

