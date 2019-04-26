//
//  LoginViewController.swift
//

import UIKit
class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
  
  var userID: String = ""
  var username: String = ""
  
  @IBOutlet weak var textBox: UITextField!
  @IBOutlet weak var startPlayButton: UIButton!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    makeTransparentNavigationBar()
    setupAddTargetIsNotEmptyTextFields()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func loginDidTouch(_ sender: Any) {
    //Если не заполнили поля
    if textBox.text!.isEmpty {
      //Меняем цвет плейсхолдеров
      textBox.attributedPlaceholder = NSAttributedString(string: "Придумайте никнейм", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100)])
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
      startPlayButton.layer.backgroundColor = UIColor.gray.cgColor
      startPlayButton.clearShadow(nameButton: startPlayButton)
      return
    }
    startPlayButton.layer.backgroundColor = UIColor(red: 232/255, green: 45/255, blue: 111/255, alpha: 100).cgColor
    startPlayButton.addShadow(nameButton: startPlayButton)
    return
  }
  
}
