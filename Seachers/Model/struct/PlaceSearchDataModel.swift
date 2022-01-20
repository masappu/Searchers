//
//  PlaceSearchDataModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/12.
//

import Foundation
import CoreLocation

struct PlaceSearchDataModel{
    var name:String
    var locaitonAtSearchPlace:CLLocationCoordinate2D?
    var searchRange:Int
    var locaitonAtCurrent:CLLocationCoordinate2D?{
        didSet{
            if self.locaitonAtSearchPlace == nil{
                self.locaitonAtSearchPlace = self.locaitonAtCurrent
            }
        }
    }
            
    init(){
        self.name = "未選択"
        self.searchRange = 1000
        self.locaitonAtSearchPlace = nil
        self.locaitonAtCurrent = nil
    }
}

