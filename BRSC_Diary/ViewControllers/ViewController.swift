//
//  ViewController.swift
//  BRSC_Diary
//
//  Created by Nikita on 27.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
import Alamofire

class ViewController: UIViewController, VCProtocol{
    let keychain = KeychainSwift()
    let settings = UserDefaults(suiteName: "settings")!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    @IBOutlet weak var nextWeek: UIButton!
    var days: [Day] = []
    var curWeek = Calendar.current.component(.weekOfYear, from: Date())
    var curYear = Calendar.current.component(.year, from: Date())
    
    @IBOutlet weak var previousWeek: RoundButton!
    
    @IBOutlet weak var refreshButton: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(settings.bool(forKey: "wasLogin")){
            updateAndShowData()
        }
     
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "DayCell", bundle: Bundle.main), forCellReuseIdentifier: "dayCell")
        days = []
        tableView.reloadData()
        tableView.separatorStyle = .none
        
        self.settings.synchronize()
        
        if(keychain.get("savedDays") != nil) {
            print(keychain.get("savedDays")!)
            days = try! JSONDecoder().decode([Day].self, from: keychain.get("savedDays")!.data(using: .utf8)!)
            
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
             if(!settings.bool(forKey: "wasLogin")){
                if let viewController = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController {
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                }
           }
    }
    
    func updateAndShowData(){
        progressBar.startAnimating()
        let user = try! JSONDecoder().decode(Array<UserInfo>.self, from: keychain.get("ids")!.data(using: .utf8)!)[settings.integer(forKey: "prefId")]
        
       // if Alamofire.Session.default.session.
      //  Alamofire.Session.default.session.invalidateAndCancel()
        API.diary.get(login: keychain.get("login")!, password: keychain.get("password")!, id: user.userId!, rooId: user.rooId!, departmentId: user.departmentId!, instituteId: user.instituteId!, year: String(curYear), week: String(curWeek)).responseJSON(completionHandler: {
            response in
            do {
                // print(String(data: response.data!, encoding: .utf8))
                guard let data = response.data else {
                    DispatchQueue.main.async {
                              let alert = UIAlertController.init(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                                     alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                                     
                                     self.show(alert, sender: nil)
                                 }
                    self.progressBar.stopAnimating()
                    self.refreshButton.isHidden = false
                    return
                }
                
                let result = try JSONDecoder().decode([Day].self, from: response.data!)
                
               
                
                DispatchQueue.main.async {
                    self.days = result
                    
                    self.keychain.set(try! JSONEncoder().encode(result), forKey: "savedDays")
                
                    self.tableView.reloadData()
                    self.progressBar.stopAnimating()
                    self.refreshButton.isHidden = false
                }
                
            } catch {
                DispatchQueue.main.async {
             let alert = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                    
                    self.show(alert, sender: nil)
                }
            }
        })
        //TODO: Year back and front support
    }
    @IBAction func onPreviousWeekButtonClicked(_ sender: Any) {
        progressBar.startAnimating()
        refreshButton.isHidden = true

        let user = try! JSONDecoder().decode(Array<UserInfo>.self, from: keychain.get("ids")!.data(using: .utf8)!)[settings.integer(forKey: "prefId")]
              
        calculateDate(isNext: false)
        
        Alamofire.Session.default.session.invalidateAndCancel()

        API.diary.get(login: keychain.get("login")!, password: keychain.get("password")!, id: user.userId!, rooId: user.rooId!, departmentId: user.departmentId!, instituteId: user.instituteId!, year: String(curYear), week: String(curWeek)).responseJSON(completionHandler: {
                  response in
                  do {
                          guard let data = response.data else {
                                        DispatchQueue.main.async {
                                                  let alert = UIAlertController.init(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                                                         alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                                                         
                                                         self.show(alert, sender: nil)
                                                     }
                            self.progressBar.stopAnimating()
                            self.refreshButton.isHidden = false
                            return }
                      let result = try JSONDecoder().decode([Day].self, from: response.data!)
        
                      DispatchQueue.main.async {
                          self.days = result
             self.keychain.set(try! JSONEncoder().encode(result), forKey: "savedDays")
                          self.tableView.reloadData()
                          self.progressBar.stopAnimating()
                        self.refreshButton.isHidden = false
                      }
                      
                  } catch {
                      DispatchQueue.main.async {
                        let alert = UIAlertController.init(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                                                            alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                                                                        
                                                                    
                          self.show(alert, sender: nil)
                      }
                  }
              })
    }
    @IBAction func onNextWeekButtonClicked(_ sender: Any) {
        progressBar.startAnimating()
        refreshButton.isHidden = true
        
        let user = try! JSONDecoder().decode(Array<UserInfo>.self, from: keychain.get("ids")!.data(using: .utf8)!)[settings.integer(forKey: "prefId")]
                
        
        calculateDate(isNext: true)
        
        Alamofire.Session.default.session.invalidateAndCancel()

         API.diary.get(login: keychain.get("login")!, password: keychain.get("password")!, id: user.userId!, rooId: user.rooId!, departmentId: user.departmentId!, instituteId: user.instituteId!, year: String(curYear), week: String(curWeek)).responseJSON(completionHandler: {
                   response in
                   do {
                         guard let data = response.data else {
                                                               DispatchQueue.main.async {
                                                                         let alert = UIAlertController.init(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                                                                                alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                                                                                
                                                                                self.show(alert, sender: nil)
                            }
                            
                            self.progressBar.stopAnimating()
                            self.refreshButton.isHidden = false
                            return }
                       let result = try JSONDecoder().decode([Day].self, from: response.data!)
                       
                      
                       
                       DispatchQueue.main.async {
                           self.days = result
              self.keychain.set(try! JSONEncoder().encode(result), forKey: "savedDays")
                           self.tableView.reloadData()
                           self.progressBar.stopAnimating()
                        self.refreshButton.isHidden = false
                       }
                       
                   } catch {
                       DispatchQueue.main.async {
                          let alert = UIAlertController.init(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                                                                             alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                           
                           self.show(alert, sender: nil)
                       }
                   }
               })
    }
    
    func calculateDate(isNext: Bool) {
        if(isNext){
            curWeek = curWeek + 1 == 52 ? 1 : curWeek + 1
            curYear = curWeek + 1 == 52 ? curYear + 1 : curYear
        } else {
            curWeek = curWeek - 1 == 0 ? 1 : curWeek - 1
            curYear = curWeek - 1 == 0 ? curYear - 1 : curYear
        }
    }
    
    func showToast(message : String, seconds: Double) {
         let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
         alert.view.backgroundColor = UIColor.black
         alert.view.alpha = 0.6
         alert.view.layer.cornerRadius = 15

        self.present(alert, animated: true)

        print("TOAST")
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
             alert.dismiss(animated: true)
         }
     }
    
    func showAlert(message: String) {
        let alert = UIAlertController.init(title: "Комментарий", message: message, preferredStyle: .actionSheet)
               
        print("ALERT")
        self.show(alert, sender: nil)
    }
    
    func getVC() -> ViewController {
        return self
    }
    @IBAction func onRefreshButtonClicked(_ sender: Any) {
        self.refreshButton.isHidden = true
        updateAndShowData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as! DayCellController
        
        cell.protocoll = self
        cell.initCell(day: days[indexPath.row])
        
        return cell
    }
    
    
}

