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
    

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    
    

    
    
    //MARK : viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Firebase reference
        scoreRef = rootRef.child("High Score")
        
    }
    


    
    @IBAction func startGameButtonDidTapped(_ sender: Any) {
        
        startGameButton.isHidden = true
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
            let alert = UIAlertController(title: "Конец игры!", message: "Вы набрали \(count) очков", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Играть снова", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction) -> Void in
                
                 let itemRef = self.scoreRef.childByAutoId()
                
                 let scoreItem = [
                    "username": self.username,
                    "highscore": self.highScore
                    ] as [String : Any]
                
                print(self.username, "XXX YYYY ", self.highScore)
                print(self.count)
                print(self.uid)
                
                itemRef.setValue(scoreItem)
 
                self.setupGame()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }

    
    
}

