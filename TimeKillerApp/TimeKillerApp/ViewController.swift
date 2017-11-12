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
    var timeStop = Date()
    
    let layerColors = [UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 0.6),
                       UIColor(red: 0.5, green: 0.1, blue: 0.5, alpha: 0.6),
                       UIColor(red: 0.5, green: 0.5, blue: 0.1, alpha: 0.6),
                       UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 0.6),
                       UIColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 0.6)]
    
    let leftLayer = CAGradientLayer()
    let rightLayer = CAGradientLayer()
    
    var rootRef = Database.database().reference()
    var scoreRef: DatabaseReference!
    var shadowButton = AddButtonShadow()
    
    @IBOutlet weak var switchModeGame: UISwitch!
    
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var tapToRestartButton: UIButton!
    @IBOutlet weak var hardcoreLabel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel! //касмотный класс для анимаций
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var faultLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
        
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        UserDefaults.standard.synchronize()
        
        //имя пользователя в левом вехнем углу
        if UserDefaults.standard.value(forKey: "userNAME") != nil {
            let name = UserDefaults.standard.value(forKey: "userNAME") as! String
            self.playerNameLabel.text = name
            scoreRef = rootRef.child("leaderboards").child(name)
        } else {
            self.playerNameLabel.text = "Имя не определено"
            scoreRef = rootRef.child("leaderboards").child("Имя не определено")
        }
        
        
        //подгрузка рекорда из UserDefaults
        if UserDefaults.standard.value(forKey: "highscore") != nil {
            highScore = UserDefaults.standard.value(forKey: "highscore") as! Int
            highScoreLabel.text = "Ваш рекорд: \(highScore)"
        }
        
        // Регистрация рекогнайзера жестов
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        view.addGestureRecognizer(tapGR)
			
        // Тень у кнопки
		shadowButton.addShadow(nameButton: startGameButton)
        
        setupGALayers()
        
        view.layer.insertSublayer(rightLayer, at: 0)
        view.layer.insertSublayer(leftLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //скрываем все лишнее, и ждем нажатия кнопки "Начать игру"
        scoreLabel.isHidden = true
        shareButton.isHidden = true
        tapToRestartButton.isHidden = true
        shareImage.isHidden = true
        
        
        startGameButton.isHidden = false
        switchModeGame.isHidden = false
        hardcoreLabel.isHidden = false
    }
    
    func setupGALayers() {
        
        rightLayer.colors = [layerColors[4].cgColor, UIColor(red: 61 / 255, green: 52 / 255, blue: 110 / 255, alpha: 0.0).cgColor]
        rightLayer.startPoint = CGPoint(x: 0, y: 0)
        rightLayer.endPoint = CGPoint(x: 0, y: 1)
        rightLayer.frame = view.bounds
        rightLayer.position.x = view.bounds.width + view.bounds.midX
        
        leftLayer.colors = [layerColors[0].cgColor, UIColor(red: 61 / 255, green: 52 / 255, blue: 110 / 255, alpha: 0.0).cgColor]
        leftLayer.startPoint = CGPoint(x: 0, y: 0)
        leftLayer.endPoint = CGPoint(x: 0, y: 1)
        leftLayer.frame = view.bounds
        leftLayer.position.x = view.bounds.midX
        
    }
    
    func changeLayers() {
        
        rightLayer.colors![0] = leftLayer.colors![0]
        
        let index = (seconds + 1) % 5
        leftLayer.colors![0] = layerColors[index].cgColor
        
        let animationRight = CABasicAnimation(keyPath: "position.x")
        animationRight.fromValue = view.bounds.midX
        animationRight.toValue = view.bounds.width + view.bounds.midX
        animationRight.duration = 0.99
        
        let animationLeft = CABasicAnimation(keyPath: "position.x")
        animationLeft.fromValue = -view.bounds.midX
        animationLeft.toValue = view.bounds.midX
        animationLeft.duration = 0.99
        
        rightLayer.add(animationRight, forKey: nil)
        leftLayer.add(animationLeft, forKey: nil)
        
    }
    
    @IBAction func switchModeDidTapped(_ sender: Any) {
        
        if switchModeGame.isOn == false {
            self.faultLabel.text = "Погрешность: 0.10"
        } else {
            self.faultLabel.text = "Погрешность отключена"
        }
        
    }
    
    
    @objc func didTap(tapGR: UITapGestureRecognizer) {
        if flPlaying {
            // Проверка точности попадания
            if fabs(Double(seconds - count - 1) + Double(seconds100) / 100) <= fault {
                // Плюс очко
                count += 1
                scoreLabel.text = "\(count)"
            } else {
                self.gameOver()
            }
        } else {
            // Если 0.4 секунды прошло, можно запускать
            if timeStop.timeIntervalSinceNow <= -0.4 && startGameButton.isHidden {
                self.setupGame()
            }
        }
    }
    
    
    @IBAction func startGameButtonDidTapped(_ sender: Any) {
        setupGame()
    }
    
    
    func setupGame() {
        
        highScoreLabel.isHidden = false
        scoreLabel.isHidden = false
        
        shareButton.isHidden = true
        startGameButton.isHidden = true
        hardcoreLabel.isHidden = true
        switchModeGame.isHidden = true
        shareImage.isHidden = true

        
        count = 0
        seconds = 0
        seconds100 = 0
        fault = switchModeGame.isOn ? 0.0 : 0.1
        
        flPlaying = true
        
        setupGALayers()
        updateTimerLabel()
        
        //для анимации
        scoreLabel.text = "\(count)"
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: timerBlock(timer:))
        
        changeLayers()
    }    
    
    func timerBlock(timer: Timer) {
        
        seconds100 += 1
        if seconds100 == 100 {
            seconds += 1
            seconds100 = 0
            
            if fault > 0 {
                fault -= 0.01
            }
            
            changeLayers()
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
        
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
        
        //переход на страницу авторизации
        let loginvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginvc, animated: true, completion: nil)
        
    }
    
    
    //конец игры
    func gameOver() {
        
        timer.invalidate()
        timeStop = Date()
        flPlaying = false
        leftLayer.position.x = leftLayer.presentation()!.position.x
        leftLayer.removeAllAnimations()
        rightLayer.position.x = rightLayer.presentation()!.position.x
        rightLayer.removeAllAnimations()
                
        shareImage.isHidden = false
        tapToRestartButton.isHidden = false
        shareButton.isHidden = false

        //добавления нового рекорда
        if count > highScore {
            
            highScore = count
            highScoreLabel.text = "Ваш рекорд: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highscore")
            
            
            //        MARK: SCLAlertView после окончания игры
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("Играть дальше", backgroundColor: UIColor(patternImage: UIImage(named: "bg")!), action: {
                //рестарт игры
                self.tapToRestartButton.isHidden = true
                self.setupGame()
            })

            alertView.addButton("Таблица лидеров", backgroundColor: UIColor(patternImage: UIImage(named: "bg")!), action: {
                //переходим на страницу с лидербоард
                self.tabBarController?.selectedIndex = 1
                
            })
            
            alertView.showSuccess("Поздравляем!", subTitle: "Вы свой побили рекорд. Ваш новый результат \(count) очков")
      
        }
        
        if let highscore = UserDefaults.standard.value(forKey: "highscore") {
            
            let scoreItem = [
                "username": UserDefaults.standard.value(forKey: "userNAME") as! String,
                "highscore": highscore
                ] as [String : Any]
            
            //отправка данных в Firebase
            self.scoreRef.setValue(scoreItem)
            
        }
    
    }
    
    
    func updateTimerLabel() {
        timerLabel.text = String(format: "00:%02d:%02d", seconds, seconds100)
    }
    
    
    
    @IBAction func tapToRestartDidTapped(_ sender: Any) {
        tapToRestartButton.isHidden = true
        self.setupGame()

    }
    
    //Кнопка поделиться
    @IBAction func shareButtonDidTapped(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: ["Хэй, мой рекорд в HardcoreTap: \(self.highScore)"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    

    
}

