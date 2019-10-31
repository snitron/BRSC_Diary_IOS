//
//  InfoCellController.swift
//  BRSC_Diary
//
//  Created by Nikita on 30.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit

class InfoCellController: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    
    func initCell(info: Info){
        label.text = info.name
        value.text = info.value
        
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.borderWidth = 1.0
    }
}
