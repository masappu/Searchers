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
    @objc dynamic var smallAreaName = String()
    @objc dynamic var latitude = Double()
    @objc dynamic var longitude = Double()
    @objc dynamic var genreName = String()
    @objc dynamic var budgetAverage = String()
    @objc dynamic var name = String()
    @objc dynamic var shop_image = String()
    @objc dynamic var url = String()
    @objc dynamic var lunch = String()
}
