//
//  TravelSearchDataModel.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/27.
//

import Foundation
import CoreLocation

struct TravelSearchDataModel{
    var checkInDate:TravelDateModel
    var checkOutDate:TravelDateModel
    var adultNum:Int
    var roomNum:Int
    var placeData:PlaceSearchDataModel?
    
    init(){
        self.checkInDate = TravelDateModel()
        self.checkOutDate = TravelDateModel()
        self.adultNum = 2
        self.roomNum = 1
        self.placeData = PlaceSearchDataModel(transitionSourceName: nil)
    }
}

