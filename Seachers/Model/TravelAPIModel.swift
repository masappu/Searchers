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
    
    func completedTravelAPIData(data:[HotelsData],pagingInfo:PagingInfo)
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
    var recordCount:Int?
    var pageCount:Int?
    var page:Int?
    var first:Int?
    var last:Int?
}

struct HotelBasicInfo:Codable{
    var hotelName:String?
    var planListUrl:String?
    var hotelMinCharge:Int?
    var address1:String?
    var latitude:Double?
    var longitude:Double?
    var nearestStation:String?
    var hotelImageUrl:String?
}

struct HotelsData{
    var hotelName = String()
    var planListUrl = String()
    var latitude = Double()
    var longitude = Double()
    var hotelMinCharge = String()
    var area = String()
    var nearestStation = String()
    var hotelImageUrl = String()
    
    init(origin data:HotelBasicInfo){
        self.hotelName = data.hotelName!
        self.planListUrl = data.planListUrl!
        self.latitude = data.latitude!
        self.longitude = data.longitude!
        
        if data.hotelMinCharge == nil{
            self.hotelMinCharge = "-"
        }else{
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            self.hotelMinCharge = "\(formatter.string(from: NSNumber(value: data.hotelMinCharge!)) ?? "-")"
        }
        
        if data.address1 == nil{
            self.area = "-"
        }else{
            self.area = data.address1!
        }
        
        if data.nearestStation == nil{
            self.nearestStation = "-"
        }else{
            self.nearestStation = data.nearestStation!
        }
        
        if data.hotelImageUrl == nil{
            self.hotelImageUrl = "http://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png"
        }else{
            self.hotelImageUrl = data.hotelImageUrl!
        }
    }
}

struct TravelRequestParameterModel{
    let searchData:TravelSearchDataModel
    let hits:Int
    let page:Int
    let elements:String  = "hotelName%2CplanListUrl%2Caddress1%2CnearestStation%2ChotelMinCharge%2ChotelImageUrl%2CrecordCount%2CpageCount%2Cpage%2Cfirst%2Clast%2Clatitude%2Clongitude"
    let datumType:Int = 1
    let sort:String = "%2BroomCharge"
    let apiKey:String = "1072027207911802205"
}

class TravelAPIModel: TravelAPIInput{
    
    private var presenter:TravelAPIOutput
    
    init(presenter:TravelAPIOutput){
        self.presenter = presenter
    }
    
    func requestData(searchData:TravelSearchDataModel,hits:Int,page:Int){
        let parameters = TravelRequestParameterModel(searchData: searchData,hits: hits,page: page)
        let urlString = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20170426?format=json&checkinDate=\(parameters.searchData.checkInDate.passDateString)&checkoutDate=\(parameters.searchData.checkOutDate.passDateString)&elements=\(parameters.elements)&adultNum=\(parameters.searchData.adultNum)&roomNum=\(parameters.searchData.roomNum)&latitude=\(parameters.searchData.placeData!.locaitonAtSearchPlace!.latitude)&longitude=\( parameters.searchData.placeData!.locaitonAtSearchPlace!.longitude)&searchRadius=\(parameters.searchData.placeData!.searchRange!.searchRange)&datumType=\(parameters.datumType)&hits=\(parameters.hits)&page=\(parameters.page)&sort=\(parameters.sort)&applicationId=\(parameters.apiKey)"
        print(urlString)
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: TravelAPIDecoder.self) { [self] response in
            switch response.result{
            case.success(let travelData):
                var passData:[HotelsData] = []
                for item in travelData.hotels{
                    if item.hotel[0].hotelBasicInfo.longitude != nil || item.hotel[0].hotelBasicInfo.latitude != nil || item.hotel[0].hotelBasicInfo.hotelName != nil || item.hotel[0].hotelBasicInfo.planListUrl != nil{
                        let newItem = HotelsData(origin: item.hotel[0].hotelBasicInfo)
                        passData.append(newItem)
                    }
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
