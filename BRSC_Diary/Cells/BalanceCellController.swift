//
//  BalanceCellController.swift
//  BRSC_Diary
//
//  Created by Nikita on 30.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import KeychainSwift

class BalanceCellController: UITableViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billNumber: UILabel!
    @IBOutlet weak var billBalance: UILabel!
    
    func initCell(balance: Balance){
        billName.text = balance.name
        billNumber.text = balance.bill
        billBalance.text = balance.balance
        
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.borderWidth = 1.0
    }
}
