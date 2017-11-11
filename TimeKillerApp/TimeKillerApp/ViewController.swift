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
    
    var highScore: Int = 0
    
    var rootRef = Database.database().reference()
    var scoreRef: DatabaseReference!
    

    @IBOutlet weak var switchModeGame: UISwitch!
    @IBOutlet weak var hardcoreLabel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var mainTapButton: UIButton! //клик в игре - который самый главный


    
    
    //MARK : viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //имя пользователя в левом вехнем углу
        if let name = UserDefaults.standard.value(forKey: "userNAME") {
            self.playerNameLabel.text = name as! String
            //Firebase
            scoreRef = rootRef.child(name as! String)
        } else {
            self.playerNameLabel.text = "???"
            //Firebase
            scoreRef = rootRef.child("nameNotDefined")
        }
        
        //скрываем все лишнее, и ждем нажатия кнопки "Начать игру"
        self.scoreLabel.isHidden = true

        //подгрузка рекорда из UserDefaults
        if UserDefaults.standard.value(forKey: "highscore") != nil {
            
            highScore = UserDefaults.standard.value(forKey: "highscore") as! Int
            self.highScoreLabel.text = "Ваш рекорд: \(highScore)"
            
        }
        

        
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
    
    
    //нажали кнопку выйти
    @IBAction func logOutButtonDidTapped(_ sender: Any) {
        
        //удаляем сохраненную инфу о юзере
        
        let alert : UIAlertController = UIAlertController()
        let exitAction = UIAlertAction(title: "Выйти", style: .destructive, handler: {action in self.exitClicked()})
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(exitAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        //фон кнопки выход на алерте
        let subView = alert.view.subviews.first!
        let alertContentView = subView.subviews.first!
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        
    }
    
    
    //нажали выход на алерте
    func exitClicked() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "userNAME")
            defaults.removeObject(forKey: "highscore")
        }
        defaults.synchronize()
        
        //переход на страницу авторизации
        let loginvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginvc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        count += 1
        scoreLabel.text = "Очки: \(count)"
        
        //добавления нового рекорда
        if count > highScore {
            
            highScore = count
            self.highScoreLabel.text = "Ваш рекорд: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highscore")
            
        }
        
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
            
            
            
             if let highscore = UserDefaults.standard.value(forKey: "highscore") {
                
                let scoreItem = [
                    "username": UserDefaults.standard.value(forKey: "userNAME") as! String,
                    "highscore": highscore
                    ] as [String : Any]
                
                //отправка данных в Firebase
                self.scoreRef.setValue(scoreItem)
                
             }
            
            
            //MARK: SCLAlertView после окончания игры
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("Начать заново") {
                //рестарт игры
                self.setupGame()
            }
            
            alertView.addButton("Таблица лидеров") {
                //переходим на страницу с лидербоард
                self.tabBarController?.selectedIndex = 1
            }
            
            alertView.showSuccess("Поздравляем!", subTitle: "Ваш результат \(count) очков")
            
        }
        
    }

    
    
}

