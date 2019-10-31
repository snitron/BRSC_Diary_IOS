//
//  BalanceController.swift
//  BRSC_Diary
//
//  Created by Nikita on 30.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import Alamofire

class BalanceController{
    public static func get(login: String, password: String) -> DataRequest {
        return AF.request("https://www.nitronapps.ru/getBalance?login=\(login)&password=\(password)", method: .get, headers: HTTPHeaders.init(["User-Agent" : "Nitron Apps BRSC Diary Http Connector"]))
    }
}
