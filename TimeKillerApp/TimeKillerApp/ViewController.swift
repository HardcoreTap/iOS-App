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
    var seconds: Int = 0               // Счетчик секунд
    var seconds10: Int = 0             // Счетчик десятых секунды
    var interval10: Double = 0.1       // Текущий интервал десятой секунды
    let deltaInterval10: Double = 0.01 // Дельта изменеия интервала секунды для ускорения
    var timer = Timer()
    var flPlaying: Bool = false // Флаг запуска игры
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
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //скрываем все лишнее, и ждем нажатия кнопки "Начать игру"
        scoreLabel.isHidden = true
        
        //подгрузка рекорда из UserDefaults
        if UserDefaults.standard.value(forKey: "highscore") != nil {
            
            highScore = UserDefaults.standard.value(forKey: "highscore") as! Int
            
            highScoreLabel.text = "Ваш рекорд: \(highScore)"
            
        }
        
        //Firebase
        scoreRef = rootRef.child("High Score")
        
        // Регистрация рекогнайзера жестов
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        view.addGestureRecognizer(tapGR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startGameButton.isHidden = false
    }
    
    @objc func didTap(tapGR: UITapGestureRecognizer) {
        if flPlaying {
            // Проверка точности попадания
            if seconds10 == 0 {
                // Плюс очко
                count += 1
                scoreLabel.text = "Очки: \(count)"
                interval10 -= deltaInterval10
            } else {
                gameOver()
            }
        }
    }
    
    func timerBlock(timer: Timer) {
        
        seconds10 += 1
        if seconds10 == 10 {
            seconds += 1
            seconds10 = 0
            
            // Смена таймеров так сделано, чтобы не было притормаживание секундомера
            let newTimer = Timer.scheduledTimer(withTimeInterval: interval10, repeats: true, block: timerBlock(timer:))
            timer.invalidate()
            self.timer = newTimer
        }
        updateTimerLabel()
        
        if seconds10 == 1 && seconds > count {
            // Пропущено нажатие
            gameOver()
        }
    }
    
    @IBAction func startGameButtonDidTapped(_ sender: Any) {
        
        highScoreLabel.isHidden = false
        scoreLabel.isHidden = false
        
        startGameButton.isHidden = true
        hardcoreLabel.isHidden = true
        switchModeGame.isHidden = true
        
        setupGame()
        
    }
    
    func setupGame() {
        
        count = 0
        seconds = 0
        seconds10 = 0
        interval10 = 0.1
        flPlaying = true
        
        updateTimerLabel()
        scoreLabel.text = "Очки: \(count)"
        
        timer = Timer.scheduledTimer(withTimeInterval: interval10, repeats: true, block: timerBlock(timer:))
        
    }
    
    func gameOver() {
        timer.invalidate()
        flPlaying = false
        
        //добавления нового рекорда
        if count > highScore {
            
            highScore = count
            highScoreLabel.text = "Ваш рекорд: \(highScore)"
            
            UserDefaults.standard.set(highScore, forKey: "highscore")
            
        }
        
        let itemRef = scoreRef.childByAutoId()
        
        let scoreItem = [
            "username": UserDefaults.standard.value(forKey: "userNAME") as! String,
            "highscore": UserDefaults.standard.value(forKey: "highscore") as! Int
            ] as [String : Any]
        
        //отправка данных в Firebase
        itemRef.setValue(scoreItem)
        
        
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
        
        alertView.showSuccess("Поздравляем!", subTitle: "Вы набрали \(count). очков")
    }
    
    func updateTimerLabel() {
        timerLabel.text = String(format: "00:%02d:%d", seconds, seconds10)
    }
    
}

