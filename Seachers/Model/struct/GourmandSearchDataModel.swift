//
//  GourmandSearchDataModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/12.
//

import Foundation
import UIKit
import CoreLocation

struct GourmandSearchDataModel{
    var place:PlaceSearchDataModel
    var genre:[GenreViewModel]
    var date:DateModel
    var memberCount:Int
    
    init(){
        self.place = PlaceSearchDataModel()
        self.genre = [GenreViewModel]()
        self.date = DateModel()
        memberCount = 2
    }
}

struct TravelSearchDataModel{
    var checkInDate:TravelDateModel
    var checkOutDate:TravelDateModel
    var adultNum:Int
    var roomNum:Int
    var latitude:CLLocationCoordinate2D?
    var longitude:CLLocationCoordinate2D?
    var searchRadius:Double
    
    init(){
        self.checkInDate = TravelDateModel()
        self.checkOutDate = TravelDateModel()
        self.adultNum = 2
        self.roomNum = 1
        self.latitude = nil
        self.longitude = nil
        self.searchRadius = 1
    }
}

struct GenreViewModel{
    var name:String
    var id:String
    var selected:Bool
    var selectbuttonImageID:String{
        switch self.selected{
        case false: return "checkmark.circle"
        case true: return "checkmark.circle.fill"
        }
    }
    var selectButtonImageColor:UIColor{
        switch self.selected{
        case false: return .lightGray
        case true: return .red
        }
    }
    init(){
        self.name = String()
        self.id = String()
        self.selected = false
    }
}



