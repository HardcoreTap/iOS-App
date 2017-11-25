//
//  LoginViewController.swift
//
//
import UIKit
import FirebaseAuth
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var userID: String = ""
    var username: String = ""
    var shadowButton = AddButtonShadow()
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var startPlayButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTargetIsNotEmptyTextFields()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        //        // Тень у кнопки
        //        shadowButton.addShadow(nameButton: startPlayButton)
        
        //сдвиг экрана наверх и обратно
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    //прикоснулись к экрану за пределами  поля ввода
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //скрываем клавиатуру
        self.view.endEditing(false)
    }
    
    
    @IBAction func loginDidTouch(_ sender: Any) {
        
        //если не заполнили поля
        if textBox.text!.isEmpty {
            
            //меняем цвет плейсхолдеров
            textBox.attributedPlaceholder = NSAttributedString(string: "Придумайте никнейм", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
        } else {
            
            //скрываем клавиатуру
            self.view.endEditing(false)
            
            Auth.auth().signInAnonymously { (user, error) in
                
                self.username = self.textBox.text!
                self.userID = user!.uid
                
                //запись в UserDefaults: userID и userNAME
                UserDefaults.standard.set(self.userID, forKey: "userID")
                UserDefaults.standard.set(self.username, forKey: "userNAME")
                
                self.performSegue(withIdentifier: "LoginToPlay", sender: nil)
                
            }
            
        }
        
    }
    
    
    
    //Разрешаем тап
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    //если клавиатура открыта
    @objc func keyboardShow(notification:NSNotification)  {
        
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    
    //если клавиатура закрыта
    @objc func keyboardHide()  {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    
    //установка целей на проверку заполнения полей
    func setupAddTargetIsNotEmptyTextFields() {
        
        //стили неактивной кнопки
        self.startPlayButton.layer.backgroundColor = UIColor.gray.cgColor
        textBox.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        
    }
    
    
    //проверка заполнения полей
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            
            let text = textBox.text, !text.isEmpty
            
            else {
                
                self.startPlayButton.layer.backgroundColor = UIColor.clear.cgColor
                self.startPlayButton.setTitleColor(UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha:1), for: UIControlState.normal)
                
                return
                
        }
        
        self.startPlayButton.layer.backgroundColor = UIColor.red.cgColor
        self.startPlayButton.setTitleColor(UIColor.white, for: .normal)
        
        return
        
    }
    
}
