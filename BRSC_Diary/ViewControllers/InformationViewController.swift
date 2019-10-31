//
//  InformationViewController.swift
//  BRSC_Diary
//
//  Created by Nikita on 31.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        let attributedString = NSMutableAttributedString(string: "Политика конфеденциальности")
        attributedString.addAttribute(.link, value: "https://www.nitronapps.ru/policy", range: NSRange(location: 0, length: 27))
        attributedString.addAttribute(.font, value: UIFont.init(name: "SegoeUI", size: 20), range: NSRange.init(location: 0, length: 27))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: 27))
     
        textView.attributedText = attributedString
    }
    
    @IBAction func onCloseButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
