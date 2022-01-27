//
//  TravelAPIModel.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/14.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol TravelAPIInput{
    
    
}

protocol TravelAPIOutput{
    
    
    
}

struct TravelData:Decodable{
    var pagingInfo:PagingInfo
    var hotels:[HotelInfo]
}

struct getData:Decodable{
    var pagingInfo:[PagingInfo]
    var hotels:[Hotel]
}

struct PagingInfo:Decodable{
    var recordCount:Int
    var pageCount:Int
    var page:Int
    var first:Int
    var last:Int
}

struct Hotel:Decodable{
    var hotel:[HotelBasicInfo]
}

struct HotelBasicInfo:Decodable{
    var hotelBasicInfo:HotelInfo
}

struct HotelInfo:Decodable{
    var hotelName:String
    var planListUrl:String
    var hotelMinCharge:Int
    var address1:String
    var nearestStation:String
    var hotelImageUrl:String
}

struct TravelsearchDataModel{
    var passData:PassData
    let elements:String
    let datumType:Int
    let hits:Int
    let page:Int
    let sort:String
    let apiKey = "1072027207911802205"
    init(){
        self.passData = PassData()
        self.elements = "hotelName%2CplanListUrl%2Caddress1%2CnearestStation%2ChotelMinCharge%2ChotelImageUrl%2CrecordCount%2CpageCount%2Cpage%2Cfirst%2Clast"
        self.datumType = 1
        self.hits = 30
        self.page = 1
        self.sort = "%2BroomCharge"
    }
}

struct PassData{
    let checkInDate:String
    let checkOutDate:String
    let adultNum:Int
    let roomNum:Int
    let latitude:Double
    let longitude:Double
    let searchRadius:Double
    init(){
        self.checkInDate = "2022-01-27"
        self.checkOutDate = "2022-01-28"
        self.adultNum = 2
        self.roomNum = 1
        self.latitude = 35.6809591
        self.longitude = 139.7673068
        self.searchRadius = 1.0
    }
}

class TravelAPIModel: TravelAPIInput{
    
    func getData(){
        let searchData = TravelsearchDataModel()
        let urlString = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20170426?format=json&checkinDate=\(searchData.passData.checkInDate)&checkoutDate=\(searchData.passData.checkOutDate)&elements=\(searchData.elements)&adultNum=\(searchData.passData.adultNum)&roomNum=\(searchData.passData.roomNum)&latitude=\(searchData.passData.latitude)&longitude=\(searchData.passData.longitude)&searchRadius=\(searchData.passData.searchRadius)&datumType=\(searchData.datumType)&hits=\(searchData.hits)&page=\(searchData.page)&sort=\(searchData.sort)&applicationId=\(searchData.apiKey)"
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: TravelData.self) { [self] response in
//            print(response.debugDescription)
            switch response.result{
            case.success(let hotelInfo):
                print(hotelInfo)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
    }
}
