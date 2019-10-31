//
//  DayCellController.swift
//  BRSC_Diary
//
//  Created by Nikita on 29.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

class DayCellController: UITableViewCell{
    @IBOutlet weak var dayTextView: UILabel!
    
    @IBOutlet weak var lessonStackView: UIStackView!
    @IBOutlet weak var lessonHeader: UIView!
    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var lessonMark: UILabel!
    @IBOutlet weak var lessonHwView: UIView!
    @IBOutlet weak var lessonHw: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var day = Day()
    var protocoll: VCProtocol? = nil
    
    func initCell(day: Day){
        dayTextView.text = day.dayName
        self.day = day
        
        lessonStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        if (day.isWeekend){
             let cell = Bundle.loadView(fromNib: "LessonCell", withType: LessonCellController.self)
            
            cell.initCell(true)
            
            lessonStackView.addArrangedSubview(cell)
        } else {
        for i in 0..<day.count {
            let cell = Bundle.loadView(fromNib: "LessonCell", withType: LessonCellController.self)
            
            cell.protocoll = protocoll!
            cell.initCell(day: day, lessonNum: i)
            
            lessonStackView.addArrangedSubview(cell)
        }
        }
        lessonHeader.backgroundColor = UIColor("#0c4f72")
        lessonHwView.backgroundColor = UIColor("#0c4f72")
        
        mainView.layer.borderColor = UIColor("#0c4f72").cgColor
        mainView.layer.borderWidth = 2.0
    }
}


extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}
