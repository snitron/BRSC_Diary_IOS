//
//  LessonCellController.swift
//  BRSC_Diary
//
//  Created by Nikita on 29.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit

class LessonCellController: UIView{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var lesson: UILabel!
    @IBOutlet weak var homework: UILabel!
  
    @IBOutlet weak var mark: UIButton!
    
    var comment = ""
    var protocoll: VCProtocol? = nil
    
    func initCell(day: Day, lessonNum: Int){
        count.text = String(lessonNum + 1)
        lesson.text = day.lessons[lessonNum]
        homework.text = day.homeworks[lessonNum]
        mark.setTitleColour(color: UIColor.black)
        mark.seTTitle(title: (day.teacherComment[lessonNum] != nil && day.teacherComment[lessonNum] != "" && day.teacherComment[lessonNum] != " ") ? trimMark(day.marks[lessonNum]) + " (i)" : trimMark(day.marks[lessonNum]))
        
        if(day.teacherComment[lessonNum] != nil && day.teacherComment[lessonNum] != "" && day.teacherComment[lessonNum] != " ") {
                comment = day.teacherComment[lessonNum]!
    
            mark.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(showComment(sender:))))
            }
        
        if(day.marks[lessonNum] == ""){
            mark.backgroundColor = UIColor.white
        } else {
            switch day.marks[lessonNum].suffix(1) {
            case "1", "2":
                mark.backgroundColor = Colors.RED_BCK
                mark.setTitleColour(color: Colors.RED_TXT)
            case "3":
                mark.backgroundColor = Colors.YELLOW_BCK
                mark.setTitleColour(color: Colors.YELLOW_TXT)
            case "4", "5":
                mark.backgroundColor = Colors.GREEN_BCK
                mark.setTitleColour(color: Colors.GREEN_TXT)
            case "H", "н", "Н":
                mark.backgroundColor = Colors.GREY_BCK
                mark.setTitleColour(color: UIColor.white)
            default:
                mark.backgroundColor = UIColor.white
                mark.setTitleColour(color: UIColor.black)
            }
        }
        
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.borderWidth = 1.0
        
    
    }
    
    func initCell(_ isWeekend: Bool) {
        lesson.text = "Выходной"
        count.text = ""
        homework.text = ""
        mark.seTTitle(title: "")
        mark.backgroundColor = UIColor.white
        
        mainView.layer.borderColor = Colors.GREY_BCK.cgColor
        mainView.layer.borderWidth = 2.0
    }
    
    @objc func showComment(sender: Any){
          if(comment != "") {
      print("ALERT")
              showAlert(message: comment)
        }
    }
    
    func trimMark(_ m: String) -> String {
        var result = ""
        for i in m.replacingOccurrences(of: "\n", with: "/") {
            if (i != " ") { result += String(i) }
        }
        
        return result
    }
    
    @IBAction func onMarkButtonTouch(_ sender: Any) {
          if(comment != "") {
        print("TOAST")
        showToast(message: "Зажмите значок (i) для просмотра комментария", seconds: 2.0)
        }
    }
    
    func showToast(message : String, seconds: Double) {
         let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
         alert.view.backgroundColor = UIColor.black
         alert.view.alpha = 0.6
         alert.view.layer.cornerRadius = 15
        alert.view.tintColor = UIColor.white

        self.parentViewController!.present(alert, animated: true)

        print("TOAST")
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
             alert.dismiss(animated: true)
         }
     }
    
    func showAlert(message: String) {
        let alert = UIAlertController.init(title: "Комментарий", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel, handler: { alertt in alert.dismiss(animated: true, completion: nil) }))
               
        print("ALERT")
        self.parentViewController!.show(alert, sender: nil)
    }
    
    
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIButton{
    func setTitleColour(color: UIColor){
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .selected)
    }
    
    func seTTitle(title: String){
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
    }
}
