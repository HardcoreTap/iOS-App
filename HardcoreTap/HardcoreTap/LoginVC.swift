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
        
        //Cдвиг экрана наверх и обратно
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    //Прикоснулись к экрану за пределами  поля ввода
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //скрываем клавиатуру
        self.view.endEditing(false)
    }
    
    
    @IBAction func loginDidTouch(_ sender: Any) {
        
        //Если не заполнили поля
        if textBox.text!.isEmpty {
            
            //Меняем цвет плейсхолдеров
            textBox.attributedPlaceholder = NSAttributedString(string: "Придумайте никнейм", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100)])
            
            
        } else {
            
            //скрываем клавиатуру
            self.view.endEditing(false)
            
            Auth.auth().signInAnonymously { (user, error) in
                
                self.username = self.textBox.text!
                //                self.userID = user!.uid
                
                //запись в UserDefaults: userID и userNAME
                //                UserDefaults.standard.set(self.userID, forKey: "userID")
                UserDefaults.standard.set(self.username, forKey: "userNAME")
                UserDefaults.standard.synchronize()
                
                self.performSegue(withIdentifier: "LoginToPlay", sender: nil)
                
            }
            
        }
        
    }
    
    
    
    //Разрешаем тап
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    //Клавиатура открыта
    @objc func keyboardShow(notification:NSNotification)  {
        
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    
    //Клавиатура закрыта
    @objc func keyboardHide()  {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    
    //Установка целей на проверку заполнения полей
    func setupAddTargetIsNotEmptyTextFields() {
        
        //стили неактивной кнопки
        self.startPlayButton.layer.backgroundColor = UIColor.gray.cgColor
        textBox.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        
    }
    
    
    //Проверка заполнения полей
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard let text = textBox.text, !text.isEmpty else {
            
            self.startPlayButton.layer.backgroundColor = UIColor.gray.cgColor
            self.shadowButton.clearShadow(nameButton: startPlayButton)

            return
            
        }
        
        self.startPlayButton.layer.backgroundColor = UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100).cgColor
        self.shadowButton.addShadow(nameButton: startPlayButton)
        
        return
        
    }
    
    
    
}
