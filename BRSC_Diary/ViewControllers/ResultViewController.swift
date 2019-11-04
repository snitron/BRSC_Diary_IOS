//
//  ResultViewController.swift
//  BRSC_Diary
//
//  Created by Nikita on 29.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import KeychainSwift
import UIColor_Hex_Swift

class ResultViewController: UIViewController {
    let keychain = KeychainSwift()
    let settings = UserDefaults(suiteName: "settings")!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    var results: [Results] = []
    
    override func viewDidLoad() {
        headerView.backgroundColor = UIColor("#0c4f72")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "ResultCell", bundle: Bundle.main), forCellReuseIdentifier: "resultCell")
        
        updateAndRefreshData()
    }
    
    
    func updateAndRefreshData(){
           progressBar.startAnimating()
           let user = try! JSONDecoder().decode(Array<UserInfo>.self, from: keychain.get("ids")!.data(using: .utf8)!)[settings.integer(forKey: "prefId")]

                 API.results.get(login: keychain.get("login")!, password: keychain.get("password")!, id: user.userId!, rooId: user.rooId!, departmentId: user.departmentId!, instituteId: user.instituteId!).responseJSON(completionHandler: {
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
                        
                       let result = try JSONDecoder().decode([Results].self, from: response.data!)
                        self.results = result
                       
                       
                         DispatchQueue.main.async {
                          // self.tableView.closeAll()
                             self.tableView.reloadData()
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
    
    @IBAction func onCloseButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultCellController
        
        cell.initCell(result: results[indexPath.row])
        
        return cell
    }
    
    
}
