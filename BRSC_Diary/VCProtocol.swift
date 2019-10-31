//
//  VCProtocol.swift
//  BRSC_Diary
//
//  Created by Nikita on 28.10.2019.
//  Copyright © 2019 Nikita. All rights reserved.
//

import Foundation

protocol VCProtocol{
    func showToast(message: String, seconds: Double)
    func showAlert(message: String)
    func getVC() -> ViewController
}
