//
//  TableControllerCell.swift
//  BRSC_Diary
//
//  Created by Nikita on 28.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import ExpandableCell
import UIColor_Hex_Swift

class TableControllerCell: ExpandableCell {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
   
    func initCell(table: Table) {
        headerTitle.text = table.lesson
        headerTitle.textColor = UIColor.white
        
        self.backgroundColor = UIColor("#0c4f72")
    }
}
