//
//  LoginController.swift
//  BRSC_Diary
//
//  Created by Nikita on 28.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Alamofire
import CoreData
import KeychainSwift
import SimpleCheckbox

class LoginViewController: UIViewController{
 
    @IBOutlet weak var loginEditText: UITextField!
    @IBOutlet weak var passwordEditText: UITextField!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkbox2: Checkbox!
    @IBOutlet weak var checkbox1: Checkbox!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var loginButton: RoundButton!
    
    let keychain = KeychainSwift()
    let settings = UserDefaults(suiteName: "settings")!
    
    override func viewDidLoad() {
       // loginButton.isEnabled = false
        
        
        let attributedString = NSMutableAttributedString(string: "Я принимаю политику конфиденциальности")
        attributedString.addAttribute(.link, value: "https://www.nitronapps.ru/policy", range: NSRange(location: 11, length: 27))
        attributedString.addAttribute(.font, value: UIFont.init(name: "SegoeUI", size: 15), range: NSRange.init(location: 0, length: 38))
        
        textView.attributedText = attributedString
        
        checkbox1.borderStyle = .square
        checkbox2.borderStyle = .square
        checkbox1.checkedBorderColor = .black
        checkbox2.checkedBorderColor = .black
        checkbox1.uncheckedBorderColor = .black
        checkbox2.uncheckedBorderColor = .black
        checkbox1.checkmarkStyle = .tick
        checkbox2.checkmarkStyle = .tick
        
 /*      checkbox1.valueChanged = { self.loginButton.isEnabled = $0 && self.checkbox2.isChecked }
        checkbox2.valueChanged = { self.loginButton.isEnabled = $0 && self.checkbox1.isChecked }*/
        
    }
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        if(checkbox1.isChecked && checkbox2.isChecked){
        
        if(loginEditText.text! != "" && passwordEditText.text! != ""){
        (sender as! UIButton).isHidden = true
        progressBar.startAnimating()
            
            loginEditText.isEnabled = false
            passwordEditText.isEnabled = false
        
         //   Alamofire.Session.default.session.invalidateAndCancel()

            API.login.get(login: loginEditText.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "", password: passwordEditText.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "").responseJSON(completionHandler: {response in
            do {
                guard let data = response.data else {
                                                       DispatchQueue.main.async {
                                                                 let alert = UIAlertController.init(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                                                                        alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                                                                        
                                                                        self.show(alert, sender: nil)
                                                                    }
                         self.progressBar.stopAnimating()
                      (sender as! UIButton).isHidden = false
                                  self.loginEditText.isEnabled = true
                                  self.passwordEditText.isEnabled = true
                    return }
                
                let userRaw = response.data ?? Data()
                let user = try JSONDecoder().decode(User.self, from: userRaw)
                var name = Name()
                
                if(user.isParent){
                    self.keychain.set(try JSONEncoder().encode(user.child_ids), forKey: "ids")
                    
                    self.settings.set(true, forKey: "isParent")
                    self.settings.set(0, forKey: "prefId")
                    name = Name(name: user.parentName, childIds: user.child_ids.map{$0.userName!})
                } else {
                    self.keychain.set(try JSONEncoder().encode([user.child_ids[0]]), forKey: "ids")
                                      
                    self.settings.set(false, forKey: "isParent")
                    self.settings.set(0, forKey: "prefId")
                    name = Name(name: nil, childIds: [user.child_ids[0].userName!])
                }
                
                self.keychain.set(self.loginEditText.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!, forKey: "login")
                self.keychain.set(self.passwordEditText.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! , forKey: "password")
                self.keychain.set(try JSONEncoder().encode(name), forKey: "names")
                
                self.settings.set(true, forKey: "wasLogin")
                (sender as! UIButton).isHidden = false
                
                DispatchQueue.main.async {
                    if let viewController = self.storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
                                      viewController.modalPresentationStyle = .fullScreen
                                      self.present(viewController, animated: true, completion: nil)
                                  }
                }
            } catch {
            DispatchQueue.main.async {
                let alert = UIAlertController.init(title: "Ошибка!", message: "Неправильный логин или пароль.", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                self.show(alert, sender: nil)
                self.progressBar.stopAnimating()
                (sender as! UIButton).isHidden = false
                
                print(error.localizedDescription)
                self.loginEditText.isEnabled = true
                self.passwordEditText.isEnabled = true
                }
            }
        })
    }
        }
        
        else {
            let alert = UIAlertController.init(title: "Примите условия использования.", message: nil, preferredStyle:
                .alert)
            
            alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: { action in alert.dismiss(animated: true, completion: nil) }))
            
            self.show(alert, sender: nil)
            
        }
    }
}

public enum Model : String {
    case simulator   = "simulator/sandbox",
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
    iPadPro10_5      = "iPad Pro 10.5\"",
    iPadPro10_5_cell = "iPad Pro 10.5\" cellular",
    iPadPro12_9      = "iPad Pro 12.9\"",
    iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    iPhone8          = "iPhone 8",
    iPhone8plus      = "iPhone 8 Plus",
    iPhoneX          = "iPhone X",
    iPhoneXS         = "iPhone XS",
    iPhoneXSmax      = "iPhone XS Max",
    iPhoneXR         = "iPhone XR",
    iPhone11         = "iPhone 11",
    iPhone11Pro      = "iPhone 11 Pro",
    iPhone11ProMax   = "iPhone 11 Pro Max",
    unrecognized     = "?unrecognized?"
}

public extension UIDevice {
     public var type: Model {
           var systemInfo = utsname()
           uname(&systemInfo)
           let modelCode = withUnsafePointer(to: &systemInfo.machine) {
               $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                   ptr in String.init(validatingUTF8: ptr)

               }
           }
           var modelMap : [ String : Model ] = [
               "i386"       : .simulator,
               "x86_64"     : .simulator,
               "iPod1,1"    : .iPod1,
               "iPod2,1"    : .iPod2,
               "iPod3,1"    : .iPod3,
               "iPod4,1"    : .iPod4,
               "iPod5,1"    : .iPod5,
               "iPad2,1"    : .iPad2,
               "iPad2,2"    : .iPad2,
               "iPad2,3"    : .iPad2,
               "iPad2,4"    : .iPad2,
               "iPad2,5"    : .iPadMini1,
               "iPad2,6"    : .iPadMini1,
               "iPad2,7"    : .iPadMini1,
               "iPhone3,1"  : .iPhone4,
               "iPhone3,2"  : .iPhone4,
               "iPhone3,3"  : .iPhone4,
               "iPhone4,1"  : .iPhone4S,
               "iPhone5,1"  : .iPhone5,
               "iPhone5,2"  : .iPhone5,
               "iPhone5,3"  : .iPhone5C,
               "iPhone5,4"  : .iPhone5C,
               "iPad3,1"    : .iPad3,
               "iPad3,2"    : .iPad3,
               "iPad3,3"    : .iPad3,
               "iPad3,4"    : .iPad4,
               "iPad3,5"    : .iPad4,
               "iPad3,6"    : .iPad4,
               "iPhone6,1"  : .iPhone5S,
               "iPhone6,2"  : .iPhone5S,
               "iPad4,1"    : .iPadAir1,
               "iPad4,2"    : .iPadAir2,
               "iPad4,4"    : .iPadMini2,
               "iPad4,5"    : .iPadMini2,
               "iPad4,6"    : .iPadMini2,
               "iPad4,7"    : .iPadMini3,
               "iPad4,8"    : .iPadMini3,
               "iPad4,9"    : .iPadMini3,
               "iPad6,3"    : .iPadPro9_7,
               "iPad6,11"   : .iPadPro9_7,
               "iPad6,4"    : .iPadPro9_7_cell,
               "iPad6,12"   : .iPadPro9_7_cell,
               "iPad6,7"    : .iPadPro12_9,
               "iPad6,8"    : .iPadPro12_9_cell,
               "iPad7,3"    : .iPadPro10_5,
               "iPad7,4"    : .iPadPro10_5_cell,
               "iPhone7,1"  : .iPhone6plus,
               "iPhone7,2"  : .iPhone6,
               "iPhone8,1"  : .iPhone6S,
               "iPhone8,2"  : .iPhone6Splus,
               "iPhone8,4"  : .iPhoneSE,
               "iPhone9,1"  : .iPhone7,
               "iPhone9,2"  : .iPhone7plus,
               "iPhone9,3"  : .iPhone7,
               "iPhone9,4"  : .iPhone7plus,
               "iPhone10,1" : .iPhone8,
               "iPhone10,2" : .iPhone8plus,
               "iPhone10,3" : .iPhoneX,
               "iPhone10,6" : .iPhoneX,
               "iPhone11,2" : .iPhoneXS,
               "iPhone11,4" : .iPhoneXSmax,
               "iPhone11,6" : .iPhoneXSmax,
               "iPhone11,8" : .iPhoneXR,
               "iPhone12,1" : .iPhone11,
               "iPhone12,3" : .iPhone11Pro,
               "iPhone12,5" : .iPhone11ProMax
           ]

       if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
               return model
           }
           return Model.unrecognized
       }
    
    public var isFiveInch: Bool {
        return type == .iPhone5 || type == .iPhone5S || type == .iPhone5C || type == .iPhoneSE
    }
}
