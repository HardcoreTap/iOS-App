//
//  ViewController.swift
//  TapMe
//
//  Created by Ahad Sheriff on 2/12/17.
//  Copyright © 2017 Ahad Sheriff. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var count: Int = 0
    var seconds: Int = 0
    var timer: Timer?
    var uid: String = ""
    let username = mainInstance.name
    
    var highScore: Int = 0
    
    var rootRef = Database.database().reference()
    var scoreRef: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupGame()
        
        // Firebase reference
        scoreRef = rootRef.child("High Score")
        
    }
    

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        count += 1
        scoreLabel.text = "Очки: \(count)"
    }
    
    
    func setupGame() {
        seconds = 30
        count = 0
        
        timerLabel.text = "Время: \(seconds)"
        scoreLabel.text = "Очки: \(count)"
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.subtractTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func subtractTime() {
        seconds -= 1
        timerLabel.text = "Время: \(seconds)"
        
        if seconds == 0 {
            timer?.invalidate()
            let alert = UIAlertController(title: "Time's Up!", message: "You scored \(count) points", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction) -> Void in
                
                 let itemRef = self.scoreRef.childByAutoId()
                 let scoreItem = [
                    "username": self.username,
                    "highscore": self.highScore
                    ] as [String : Any]
                 
                 itemRef.setValue(scoreItem)
 
                self.setupGame()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func restartPressed(_ sender: Any) {
        print("Global username: ", self.username)
        timer?.invalidate()
        self.viewDidLoad()
    }
    
    
    
}

