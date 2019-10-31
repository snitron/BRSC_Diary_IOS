//
//  TableQuarterCell.swift
//  BRSC_Diary
//
//  Created by Nikita on 28.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import ExpandableCell
import UIColor_Hex_Swift

class TableQuarterCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var marks: UILabel!
    @IBOutlet weak var average: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    func initCell(pos: Int, marks: String, average: String){
        switch pos {
        case 1:
            name.text = "I"
        case 2:
            name.text = "II"
        case 3:
            name.text = "III"
        case 4:
            name.text = "IV"
        default:
            name.text = "I"
        }
        
        self.marks.text = {
            var result = ""
            
            for i in marks {
                result += String(i) + " "
            }
            
            return result
        }()
        
        self.average.text = average
        
        if(average != ""){
        switch Double(average.replacingOccurrences(of: ",", with: "."))! {
        case 0..<2.5:
            self.average.textColor = Colors.RED_TXT
            self.average.backgroundColor = Colors.RED_BCK
        case 2.5..<3.5:
            self.average.textColor = Colors.YELLOW_TXT
            self.average.backgroundColor = Colors.YELLOW_BCK
        default:
            self.average.textColor = Colors.GREEN_TXT
            self.average.backgroundColor = Colors.GREEN_BCK
        }
        }
        
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor.gray.cgColor
    }
}
