//
//  TravelSearchDataModel.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/27.
//

import Foundation
import CoreLocation

struct TravelSearchDataModel{
    var checkInDate:CheckInDate
    var checkOutDate:CheckOutDate
    var adultNum:Int
    var roomNum:Int
    var placeData:PlaceSearchDataModel?
    
    init(){
        self.checkInDate = CheckInDate()
        self.checkOutDate = CheckOutDate()
        self.adultNum = 2
        self.roomNum = 1
        self.placeData = PlaceSearchDataModel(transitionSourceName: nil)
    }
}

