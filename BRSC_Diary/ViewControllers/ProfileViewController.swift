//
//  ProfileViewController.swift
//  BRSC_Diary
//
//  Created by Nikita on 30.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
import Alamofire

class ProfileViewController: UIViewController {
    let keychain = KeychainSwift()
    let settings = UserDefaults(suiteName: "settings")!
    
    var balance: [Balance] = []
    var info: [Info] = []
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var parentName: UILabel!
    @IBOutlet weak var myChildrenButton: RoundButton!
    @IBOutlet weak var balanceTableView: UITableView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var parentView: UIView!
    
    var user: UserInfo = UserInfo()
    var names: Name = Name()
    
    override func viewDidLoad() {
        user = try! JSONDecoder().decode(Array<UserInfo>.self, from: self.keychain.get("ids")!.data(using: .utf8)!)[settings.integer(forKey: "prefId")]
        
        names = try! JSONDecoder().decode(Name.self, from: self.keychain.get("names")!.data(using: .utf8)!)
        
        balanceTableView.delegate = self
        balanceTableView.dataSource = self
        balanceTableView.separatorStyle = .none
        balanceTableView.register(UINib.init(nibName: "BalanceCell", bundle: Bundle.main), forCellReuseIdentifier: "balanceCell")
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.separatorStyle = .none
        infoTableView.register(UINib.init(nibName: "InfoCell", bundle: Bundle.main), forCellReuseIdentifier: "infoCell")
        
        updateAndRefreshData()
    }
    
    func updateAndRefreshData(){
        balance.removeAll()
        info.removeAll()
        
        balanceTableView.reloadData()
        infoTableView.reloadData()
        
        progressBar.startAnimating()
        initPerson()

      //  Alamofire.Session.default.session.invalidateAndCancel()

                     API.balance.get(login: keychain.get("login")!, password: keychain.get("password")!).responseJSON(completionHandler: {
                         response in
                         do {
                            guard let data = response.data else {
                                                                  DispatchQueue.main.async {
                                                                            let alert = UIAlertController.init(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                                                                                   alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
                                                                                   
                                                                                   self.show(alert, sender: nil)
                                                                               }
                                 self.progressBar.stopAnimating()
                                                      return }
                        
                           let result = try JSONDecoder().decode(BalanceCall.self, from: response.data!)
                            
                            if(result.isChild){
                                self.balance = result.res
                                self.info = result.info
                                
                                
                            } else {
                                self.balance = result.res.filter({$0.child_name == self.names.childIds![self.settings.integer(forKey: "prefId")]})
                                self.info = result.info
                                                             
                                
                            }
                           
                           
                             DispatchQueue.main.async {
                              // self.tableView.closeAll()
                                self.balanceTableView.reloadData()
                                self.infoTableView.reloadData()
                             //  self.tableView.openAll()
                              
                                 self.progressBar.stopAnimating()
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
    
    func initPerson() {
        if(names.name != nil){
            parentView.removeConstraints(parentView.constraints.filter({$0.firstAttribute == .height}))
            parentView.addConstraint(NSLayoutConstraint.init(item: parentView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 80))
            
                  parentName.isHidden = false
                  parentName.text = "Родитель: \(names.name!)"
                  myChildrenButton.isHidden = false
                  
                  self.name.text = names.childIds![self.settings.integer(forKey: "prefId")]
              } else {
            parentView.removeConstraints(parentView.constraints.filter({$0.firstAttribute == .height}))
            parentView.addConstraint(NSLayoutConstraint.init(item: parentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0))
            
                  parentName.isHidden = true
                  myChildrenButton.isHidden = true
                  
                  self.name.text = names.childIds![0]
              }
    }
    
    @IBAction func onMyChildrenButtonClicked(_ sender: Any) {
        let alert = UIAlertController.init(title: "Выберите ребёнка для просмотра дневника", message: nil, preferredStyle: .actionSheet)
        
        for i in 0 ..< names.childIds!.count {
            alert.addAction(UIAlertAction.init(title: names.childIds![i], style: .default, handler: { action in
                self.settings.set(i, forKey: "prefId")
                self.updateAndRefreshData()
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)}))
        
        self.show(alert, sender: nil)
    }
    @IBAction func onCloseButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onQuitButtonClicked(_ sender: Any) {
        keychain.clear()
        UserDefaults.standard.removePersistentDomain(forName: "settings")
        
        let loginVC = storyboard!.instantiateViewController(identifier: "LoginViewController")
        
        loginVC.modalPresentationStyle = .fullScreen
        
        show(loginVC, sender: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case balanceTableView:
            return balance.count
        case infoTableView:
            return info.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case balanceTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "balanceCell") as! BalanceCellController
            
            cell.initCell(balance: balance[indexPath.row])
            
            return cell
            
        case infoTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoCellController
            
            cell.initCell(info: info[indexPath.row])
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
}
