//
//  Name.swift
//  BRSC_Diary
//
//  Created by Nikita on 29.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation

class Name: Codable{
    var childIds: [String]? = [""]
    var name: String? = ""
    
    init() {}
    
    init(name: String?, childIds: [String]?){
        self.name = name
        self.childIds = childIds
    }
}
