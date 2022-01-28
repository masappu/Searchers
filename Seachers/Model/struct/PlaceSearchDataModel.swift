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
        self.locaitonAtCurrent = nil
    }
}



struct SearchRange{
    
    var searchRange:String
    var transitionSourceName:String?
    
    private func initialsearchRange() -> String{
        
        var string = String()
        if transitionSourceName == "TravelSearch"{
            string = "1"
        }else if transitionSourceName == "Gourmand"{
            string = "300"
        }
        return string
    }
    
    var searchRangeLabelText:String{
        var unitString = String()
        if transitionSourceName == "TravelSearch"{
            unitString = "\(searchRange)km"
        }else if transitionSourceName == "Gourmand"{
            unitString = "\(searchRange)m"
        }
        return unitString
    }
    
    init(transitionSourceName:String?){
        self.searchRange = String()
        self.transitionSourceName = transitionSourceName
        self.searchRange = initialsearchRange()
    }
}
