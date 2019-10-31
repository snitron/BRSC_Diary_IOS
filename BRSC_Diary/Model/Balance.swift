//
//  Balance.swift
//  BRSC_Diary
//
//  Created by Nikita on 30.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation

class Balance: Codable {
    var name: String? = ""
    var bill: String? = ""
    var balance: String? = ""
    var pay: String? = ""
    var child_name: String? = ""
}

class BalanceCall: Codable {
    var isChild: Bool = false
    var res: [Balance] = []
    var info: [Info] = []
}
