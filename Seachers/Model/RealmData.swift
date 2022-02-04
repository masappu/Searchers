//
//  RealmData.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/19.
//

import Foundation
import RealmSwift

class favShopData: Object{
    @objc dynamic var smallAreaName:String = ""
    @objc dynamic var latitude:Double = 0.0
    @objc dynamic var longitude:Double = 0.0
    @objc dynamic var genreName:String = ""
    @objc dynamic var budgetAverage:String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var shop_image:String = ""
    @objc dynamic var url:String = ""
    @objc dynamic var lunch:String = ""
}

class favProductData: Object{
    @objc dynamic var name:String = ""
    @objc dynamic var product_image:String = ""
    @objc dynamic var url:String = ""
    @objc dynamic var price:String = ""
}

class favHotelData: Object{
    @objc dynamic var hotelName:String = ""
    @objc dynamic var latitude:Double = 0.0
    @objc dynamic var longitude:Double = 0.0
    @objc dynamic var planListUrl:String = ""
    @objc dynamic var hotelMinCharge:String = ""
    @objc dynamic var area:String = ""
    @objc dynamic var nearestStation:String = ""
    @objc dynamic var hotelImageUrl:String = ""
}
