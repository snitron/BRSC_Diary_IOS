//
//  TableViewController.swift
//  BRSC_Diary
//
//  Created by Nikita on 28.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
import Alamofire
import ExpandableCell

class TableViewController: UIViewController {
    let keychain = KeychainSwift()
    let settings = UserDefaults(suiteName: "settings")!
    
    var readyCells: [[TableQuarterCell]] = Array<Array<TableQuarterCell>>()
    
    var tables: [Table] = []
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var tableView: ExpandableTableView!
    
    override func viewDidLoad() {
        tableView.expandableDelegate = self
        tableView.animation = .automatic
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib.init(nibName: "TableCell", bundle: Bundle.main), forCellReuseIdentifier: "tableCell")
        tableView.register(UINib.init(nibName: "TableQuarterCell", bundle: Bundle.main), forCellReuseIdentifier: "tableQuarterCell")
        
        updateAndRefreshData()
    }
    
    func updateAndRefreshData(){
        progressBar.startAnimating()
        let user = try! JSONDecoder().decode(Array<UserInfo>.self, from: keychain.get("ids")!.data(using: .utf8)!)[settings.integer(forKey: "prefId")]

              API.table.get(login: keychain.get("login")!, password: keychain.get("password")!, id: user.userId!, rooId: user.rooId!, departmentId: user.departmentId!, instituteId: user.instituteId!).responseJSON(completionHandler: {
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
                    
                    let result = try JSONDecoder().decode([Table].self, from: response.data!)
                    
                    
                      DispatchQueue.main.async {
                        self.tables = result
                       // self.tableView.closeAll()
                          self.tableView.reloadData()
                        self.tableView.openAll()
                       
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
    @IBAction func navigationBarClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TableViewController: ExpandableDelegate {
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
       // return [readyCells[indexPath.row][0].bounds.size.height, readyCells[indexPath.row][1].bounds.size.height, readyCells[indexPath.row][2].bounds.size.height, readyCells[indexPath.row][3].bounds.size.height]
        
        return [50, 50, 50, 50]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        var cells: [TableQuarterCell] = []
           for i in 0..<4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableQuarterCell") as! TableQuarterCell
                 
                 switch i {
                 case 0:
                    cell.initCell(pos: 1, marks: tables[indexPath.row].m1!, average: tables[indexPath.row].average_mark1!)
                 case 1:
                     cell.initCell(pos: 2, marks: tables[indexPath.row].m2!, average: tables[indexPath.row].average_mark2!)
                 case 2:
                     cell.initCell(pos: 3, marks: tables[indexPath.row].m3!, average: tables[indexPath.row].average_mark3!)
                 case 3:
                     cell.initCell(pos: 4, marks: tables[indexPath.row].m4!, average: tables[indexPath.row].average_mark4!)
                     
                 default:
                     break
                 }
                 
            cells.append(cell)
             }
        
        if(!readyCells.contains(cells)){
            readyCells.insert(cells, at: indexPath.row)
        }
    
        return cells
             
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableControllerCell
        
        cell.initCell(table: tables[indexPath.row])
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        let cell = expandedCell as! TableControllerCell
        
        print(String(indexPath.row) + "\n")
        
        if(cell.isExpanded()){
            cell.close()
            expandableTableView.close(at: indexPath)
        } else {
            cell.open()
            expandableTableView.open(at: indexPath)
        }
    }

}
