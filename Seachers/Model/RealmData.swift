//
//  RealmData.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/19.
//

import Foundation
import RealmSwift

class favShopData: Object{
//    @objc dynamic var shopData = ShopData()
    @objc dynamic var smallAreaName:String
    @objc dynamic var latitude:Double
    @objc dynamic var longitude:Double
    @objc dynamic var genreName:String
    @objc dynamic var budgetAverage:String
    @objc dynamic var name:String
    @objc dynamic var shop_image:String
    @objc dynamic var url:String
    @objc dynamic var lunch:String
    
    init(smallAreaName:String,latitude:Double,longitude:Double,genreName:String,budgetAverage:String,name:String,shop_image:String,url:String,lunch:String){
        self.smallAreaName = smallAreaName
        self.latitude = latitude
        self.longitude = longitude
        self.genreName = genreName
        self.budgetAverage = budgetAverage
        self.name = name
        self.shop_image = shop_image
        self.url = url
        self.lunch = lunch
    }
}
