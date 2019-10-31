//
//  TableController.swift
//  BRSC_Diary
//
//  Created by Nikita on 28.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import Alamofire

class TableController{
    /*
    public static func get(login: String, password: String, id: String, rooId: String, departmentId: String, instituteId: String, year: String) -> Observable<[Day]> {
        return APIRequest<[Day]>("parseMain?login=\(login)&password=\(password)&id=\(id)&rooId=\(rooId)&departmentId=\(departmentId)&instituteId=\(instituteId)&year=\(year)").method(.get).headers(["User-Agent": "Nitron Apps BRSC Diary Http Connector"]).observable.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)).observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }*/
    
    public static func get(login: String, password: String, id: String, rooId: String, departmentId: String, instituteId: String) -> DataRequest {
        return AF.request("https://www.nitronapps.ru/parseTable?login=\(login)&password=\(password)&id=\(id)&departmentId=\(departmentId)&rooId=\(rooId)&instituteId=\(instituteId)", method: .get, headers: HTTPHeaders.init(["User-Agent" : "Nitron Apps BRSC Diary Http Connector"]))
    }
}
