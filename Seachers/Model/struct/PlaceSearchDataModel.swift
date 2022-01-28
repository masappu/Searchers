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
    var searchRange:SearchRange?
//    var checkInDate:TravelDateModel
//    var checkOutDate:TravelDateModel
//    var adultNum:Int
//    var roomNum:Int
    var locaitonAtCurrent:CLLocationCoordinate2D?{
        didSet{
            if self.locaitonAtSearchPlace == nil{
                self.locaitonAtSearchPlace = self.locaitonAtCurrent
            }
        }
    }
            
    init(transitionSourceName:String?){
        self.name = "未選択"
        self.searchRange = SearchRange(transitionSourceName: transitionSourceName)
        self.locaitonAtSearchPlace = nil
//        self.checkInDate = TravelDateModel()
//        self.checkOutDate = TravelDateModel()
//        self.adultNum = 2
//        self.roomNum = 1
        self.locaitonAtCurrent = nil
    }
}



struct SearchRange{
    
    var searchRange:String
    var transitionSourceName:String?
    
    private mutating func initialsearchRange() -> String{
        
        if transitionSourceName == "TravelSearch"{
            self.searchRange = "1"
        }else if transitionSourceName == "Gourmand"{
            self.searchRange = "300"
        }
        return self.searchRange
    }
    
    var unit:String{
        var unitString = String()
        if transitionSourceName == "TravelSearch"{
            unitString = "km 以内"
        }else if transitionSourceName == "Gourmand"{
            unitString = "m 以内"
        }
        return unitString
    }
    
    init(transitionSourceName:String?){
        self.searchRange = String()
        self.transitionSourceName = transitionSourceName
        self.searchRange = initialsearchRange()
    }
}
