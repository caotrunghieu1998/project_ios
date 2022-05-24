//
//  UserModel.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 23/05/2022.
//

import Foundation
import UIKit

class UserModel{
    var id:Int
    var name:String
    var email:String
    var phone:String
    var type:String
    var isConfirm:Bool
    var isActive:Bool
    
    init(
        id:Int,
        name:String,
        email:String,
        phone:String,
        type:String,
        isConfirm:Bool,
        isActive:Bool
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.type = type
        self.isConfirm = isConfirm
        self.isActive = isActive
    }
}
