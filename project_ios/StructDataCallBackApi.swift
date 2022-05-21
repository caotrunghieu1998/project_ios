//
//  StructDataCallBackApi.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 03/05/2022.
//

import UIKit

struct DataCallBackUserLogin {
    let isSuccess:Bool
    let token:String?
    let userName:String?
    let error:String?
    let system_error:String?
}

struct DataCallBackDataIsMessage {
    let isSuccess:Bool
    let message:String?
    let error:String?
    let system_error:String?
}

