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
    
    var count: Int = 0                 // Счетчик очков
    var seconds: Int = 0               // Счетчик секунд
    var seconds100: Int = 0            // Счетчик десятых секунды
    var fault = 0.1 {                  // Погрешность
        didSet {
            faultLabel.text = "Погрешность: \(fault)"
        }
    }
    var timer = Timer()
    var flPlaying: Bool = false // Флаг запуска игры
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
    @IBOutlet weak var faultLabel: UILabel!
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //имя пользователя в левом вехнем углу
        if UserDefaults.standard.value(forKey: "userNAME") != nil {
            let name = UserDefaults.standard.value(forKey: "userNAME") as! String
            self.playerNameLabel.text = name
            scoreRef = rootRef.child("leaderboards").child(name)
        } else {
            self.playerNameLabel.text = "Имя не определено"
            scoreRef = rootRef.child("leaderboards").child("Имя не определено")
        }
        
        //скрываем все лишнее, и ждем нажатия кнопки "Начать игру"
        scoreLabel.isHidden = true
        
        //подгрузка рекорда из UserDefaults
        if UserDefaults.standard.value(forKey: "highscore") != nil {
            highScore = UserDefaults.standard.value(forKey: "highscore") as! Int
            highScoreLabel.text = "Ваш рекорд: \(highScore)"
        }
        
        // Регистрация рекогнайзера жестов
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        view.addGestureRecognizer(tapGR)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startGameButton.isHidden = false
        switchModeGame.isHidden = false
        hardcoreLabel.isHidden = false
    }
    
    
    @IBAction func switchModeDidTapped(_ sender: Any) {
        
        if switchModeGame.tag == 0 {
            faultLabel.text = "Погрешность: 0.1"
        } else {
            faultLabel.text = "Погрешность: 0.0\nТы уверен?"
        }
        
    }
    
    
    @objc func didTap(tapGR: UITapGestureRecognizer) {
        if flPlaying {
            // Проверка точности попадания
            if fabs(Double(seconds - count - 1) + Double(seconds100) / 100) <= fault {
                // Плюс очко
                count += 1
                scoreLabel.text = "Очки: \(count)"
            } else {
                self.gameOver()
            }
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
        seconds100 = 0
        fault = switchModeGame.isOn ? 0.0 : 0.1
        
        flPlaying = true
        
        updateTimerLabel()
        
        scoreLabel.text = "Очки: \(count)"
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: timerBlock(timer:))
        
    }    
    
    func timerBlock(timer: Timer) {
        
        seconds100 += 1
        if seconds100 == 100 {
            seconds += 1
            seconds100 = 0
            
            if fault > 0 {
                fault -= 0.01
            }
            
        }
        updateTimerLabel()
        
        if Double(seconds - count - 1) + Double(seconds100) / 100 > fault {
            // Пропущено нажатие
            gameOver()
        }
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
    
    
    func gameOver() {
        
        timer.invalidate()
        flPlaying = false
        
        //добавления нового рекорда
        if count > highScore {
            
            highScore = count
            highScoreLabel.text = "Ваш рекорд: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highscore")
            
        }
        
        if let highscore = UserDefaults.standard.value(forKey: "highscore") {
            
            let scoreItem = [
                "username": UserDefaults.standard.value(forKey: "userNAME") as! String,
                "highscore": highscore
                ] as [String : Any]
            
            //отправка данных в Firebase
            self.scoreRef.setValue(scoreItem)
        }
    
        
//        MARK: SCLAlertView после окончания игры
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
        timerLabel.text = String(format: "00:%02d:%02d", seconds, seconds100)
    }
    
}

