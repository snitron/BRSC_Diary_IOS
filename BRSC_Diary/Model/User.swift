//
//  User.swift
//  BRSC_Diary
//
//  Created by Nikita on 27.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation

struct User: Codable {
    var isParent: Bool = false
    var parentName: String? = ""
    var child_ids = Array<UserInfo>()
}

struct UserInfo: Codable {
    var rooId: String? = ""
    var departmentId: String? = ""
    var instituteId: String? = ""
    var userId: String? = ""
    var userName: String? = ""
}
