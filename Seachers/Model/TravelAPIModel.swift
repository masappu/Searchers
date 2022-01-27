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
    
    func requestData(searchData:TravelSearchDataModel,hits:Int,page:Int)
}

protocol TravelAPIOutput{
    
    func completedTravelAPIData(data:[HotelBasicInfo],pagingInfo:PagingInfo)
    func requestfailed(error:Error)
    
}

struct TravelAPIDecoder:Codable{
    var pagingInfo:PagingInfo
    var hotels:[Hotels]
}

struct Hotels:Codable{
    var hotel:[Hotel]
}

struct Hotel:Codable{
    var hotelBasicInfo:HotelBasicInfo
}

struct PagingInfo:Codable{
    var recordCount:Int
    var pageCount:Int
    var page:Int
    var first:Int
    var last:Int
}

struct HotelBasicInfo:Codable{
    var hotelName:String?
    var planListUrl:String?
    var hotelMinCharge:Int?
    var address1:String?
    var nearestStation:String?
    var hotelImageUrl:String?
}


struct TravelRequestParameterModel{
    let searchData:PassData
    let hits:Int
    let page:Int
    let elements:String  = "hotelName%2CplanListUrl%2Caddress1%2CnearestStation%2ChotelMinCharge%2ChotelImageUrl%2CrecordCount%2CpageCount%2Cpage%2Cfirst%2Clast"
    let datumType:Int = 1
    let sort:String = "%2BroomCharge"
    let apiKey:String = "1072027207911802205"
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
    
    private var presenter:TravelAPIOutput
    
    init(presenter:TravelAPIOutput){
        self.presenter = presenter
    }
    
    func requestData(searchData:TravelSearchDataModel,hits:Int,page:Int){
        let parameters = TravelRequestParameterModel(searchData: PassData(),hits: hits,page: page)
        let urlString = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20170426?format=json&checkinDate=\(parameters.searchData.checkInDate)&checkoutDate=\(parameters.searchData.checkOutDate)&elements=\(parameters.elements)&adultNum=\(parameters.searchData.adultNum)&roomNum=\(parameters.searchData.roomNum)&latitude=\(parameters.searchData.latitude)&longitude=\(parameters.searchData.longitude)&searchRadius=\(parameters.searchData.searchRadius)&datumType=\(parameters.datumType)&hits=\(parameters.hits)&page=\(parameters.page)&sort=\(parameters.sort)&applicationId=\(parameters.apiKey)"
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: TravelAPIDecoder.self) { [self] response in
            switch response.result{
            case.success(let travelData):
                var passData:[HotelBasicInfo] = []
                for item in travelData.hotels{
                    passData.append(item.hotel[0].hotelBasicInfo)
                }
                presenter.completedTravelAPIData(data: passData, pagingInfo: travelData.pagingInfo)
                break
            case .failure(let error):
                presenter.requestfailed(error: error)
                break
            }
        }
    }
}
