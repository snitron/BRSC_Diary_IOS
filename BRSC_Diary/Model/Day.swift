//
//  Day.swift
//  BRSC_Diary
//
//  Created by Nikita on 27.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation

class Day: Codable {
    var count: Int = 0
    var lessons: [String] = [""]
    var homeworks: [String] = [""]
    var marks: [String] = [""]
    var isWeekend: Bool = false
    var dayName: String = ""
    var teacherComment: [String?] = [""]
    var hrefHwNames: [[String?]?] = [[""]]
    var hrefHw: [[String?]?] = [[""]]
}
