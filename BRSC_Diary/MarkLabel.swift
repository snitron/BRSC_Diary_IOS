//
//  MarkLabel.swift
//  BRSC_Diary
//
//  Created by Nikita on 28.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import UIKit

class MarkLabel: UILabel{
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
}
