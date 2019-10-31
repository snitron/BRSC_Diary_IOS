//
//   ResultController.swift
//  BRSC_Diary
//
//  Created by Nikita on 29.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import Alamofire

class ResultController{
    public static func get(login: String, password: String, id: String, rooId: String, departmentId: String, instituteId: String) -> DataRequest {
        return AF.request("https://www.nitronapps.ru/parseResults?login=\(login)&password=\(password)&id=\(id)&departmentId=\(departmentId)&rooId=\(rooId)&instituteId=\(instituteId)", method: .get, headers: HTTPHeaders.init(["User-Agent" : "Nitron Apps BRSC Diary Http Connector"]))
    }
}
