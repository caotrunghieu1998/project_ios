//
//  ProductModel.swift
//  Et O Et Coffee Manager
//
//  Created by Cao Trung Hieu on 24/05/2022.
//

import Foundation
import UIKit
class ProductModel {
    var id:Int
    var image:UIImage
    var name:String
    var price:Int
    var quantity:Int
    var type:String
    var unit:String
    var isActive:Bool
    
    init(
        id:Int,
        image:UIImage,
        name:String,
        price:Int,
        quantity:Int,
        type:String,
        unit:String,
        isActice:Bool
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.price = price
        self.quantity = quantity
        self.type = type
        self.unit = unit
        self.isActive = isActice
    }
}
