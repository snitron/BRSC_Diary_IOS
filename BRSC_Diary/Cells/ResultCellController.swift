//
//  ResultCellController.swift
//  BRSC_Diary
//
//  Created by Nikita on 29.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit

class ResultCellController: UITableViewCell {
    
    @IBOutlet weak var lesson: UILabel!
    @IBOutlet weak var marks: UIStackView!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var exam: UILabel!
    @IBOutlet weak var res: UILabel!
    
    @IBOutlet weak var third: UILabel!
    
    @IBOutlet weak var fourth: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    func initCell(result: Results) {
        lesson.text = result.lesson
            
        first.text = result.m1
        second.text = result.m2
        
        if(!result.isHalfYear){
            third.text = result.m3
            fourth.text = result.m4
        }
        
        exam.text = result.test
        year.text = result.y
        res.text = result.res
        
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.borderWidth = 1.0
    }
    
}

