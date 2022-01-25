//
//  productData.swift
//  Seachers
//
//  Created by 西林遼太郎 on 2022/01/21.
//

import Foundation
import RealmSwift

class favProductData: Object{
    @objc dynamic var name:String = ""
    @objc dynamic var product_image:String = ""
    @objc dynamic var url:String = ""
    @objc dynamic var price:Int = 0
}


