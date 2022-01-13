//
//  PlaceSearchDataModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/12.
//

import Foundation

struct PlaceSearchDataModel{
    var name:String
    var latitude:String
    var longitude:String
    var searchRange:Int
    
    init(){
        self.name = "未選択"
        self.latitude = "現在の緯度"
        self.longitude = "現在の経度"
        self.searchRange = 1000
    }
}
