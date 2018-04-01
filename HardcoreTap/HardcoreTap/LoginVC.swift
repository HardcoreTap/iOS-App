//
//  LoginViewController.swift
//
//

import UIKit
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
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)    
  }
  
  @IBAction func loginDidTouch(_ sender: Any) {
    //Если не заполнили поля
    if textBox.text!.isEmpty {
      //Меняем цвет плейсхолдеров
      textBox.attributedPlaceholder = NSAttributedString(string: "Придумайте никнейм", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100)])
    } else {
      //скрываем клавиатуру
      self.view.endEditing(false)
      self.username = self.textBox.text!
      UserDefaults.standard.set(self.username, forKey: "userNAME")
      UserDefaults.standard.synchronize()
      self.performSegue(withIdentifier: "LoginToPlay", sender: nil)
    }
  }
  
  //Установка целей на проверку заполнения полей
  func setupAddTargetIsNotEmptyTextFields() {
    //Cтили неактивной кнопки
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
