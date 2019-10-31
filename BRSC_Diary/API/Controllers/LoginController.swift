//
//  LoginController.swift
//  BRSC_Diary
//
//  Created by Nikita on 27.09.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class LoginController{
    public static func get(login: String, password: String) -> DataRequest {
        return AF.request("https://www.nitronapps.ru/getId?login=\(login)&password=\(password)", method: .get, headers: HTTPHeaders.init(["User-Agent" : "Nitron Apps BRSC Diary Http Connector"]))
    }
}
