//
//  LoginViewController.swift
//
//
import UIKit
import FirebaseAuth
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    var userID: String = ""
    var username: String = ""
    
    
    @IBOutlet weak var textBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.textBox.delegate = self
        
    }
    
    @IBAction func loginDidTouch(_ sender: Any) {
        Auth.auth().signInAnonymously { (user, error) in
            if let user = user {
                
                self.username = self.textBox.text!
                self.userID = user.uid
                
                //запись в UserDefaults: userID и userNAME
                UserDefaults.standard.set(self.userID, forKey: "userID")
                UserDefaults.standard.set(self.username, forKey: "userNAME")
                
            } else {
                print("No user is signed in.")
            }
            
            self.performSegue(withIdentifier: "LoginToPlay", sender: nil)
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
