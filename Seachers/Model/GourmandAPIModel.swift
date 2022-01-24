//
//  GourmandAPIModel.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/14.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol GourmandAPIInput{
    func setData(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int)
    var shopDataArray: [ShopData] {get set}
}

protocol GourmandAPIOutput{
    func resultAPIData(shopDataArray: [ShopData],idoValue:Double,keidoValue:Double)
}

struct ShopData: Decodable  {
    var smallAreaName:String?
    var latitude:Double?
    var longitude:Double?
    var genreName:String?
    var budgetAverage:String?
    var name:String?
    var shop_image:String?
    var url:String?
    var lunch:String?
}

class GourmandAPIModel: GourmandAPIInput{
    
    
    var presenter:GourmandAPIOutput
    var apikey = "28d7568c4dcea09f"
    var idoValue = Double()
    var keidoValue = Double()
    var rangeCount = Int()
    var memberCount = Int()
    var genreString = String()
    var shopDataArray = [ShopData]()
    let rangeArray = [20,40,60,80,100]
    
    init(presenter:GourmandAPIOutput){
        self.presenter = presenter
        self.shopDataArray = []
    }
    
    //JSON解析を行う
    func setData(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int){
        
        self.shopDataArray = []
        self.idoValue = gourmandSearchData.place.locaitonAtSearchPlace!.latitude
        self.keidoValue = gourmandSearchData.place.locaitonAtSearchPlace!.longitude
        self.rangeCount = rangeCount
        self.memberCount = gourmandSearchData.memberCount
        for i in gourmandSearchData.genre{
            self.genreString = genreString + "," + i.id
            print(genreString)
        }
        
        print(rangeCount)
        
        let urlString = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apikey)&lat=\(idoValue)&lng=\(keidoValue)&range=\(rangeCount)&genre=\(genreString)&count=100&party_capacity=\(memberCount)&format=json"
        //        let encodeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: ShopData.self) { [self] response in
            
            print(response.debugDescription)
            switch response.result{
                
            case.success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    var totalHitCount = json["results"]["results_available"].int
                    if totalHitCount! > rangeArray[rangeCount - 1]{
                        totalHitCount = rangeArray[rangeCount - 1]
                    }
                    if totalHitCount != 0{
                        
                        print(totalHitCount)
                        for i in 0...totalHitCount! - 1{
                            
                            if  json["results"]["shop"][i]["small_area"]["name"].isEmpty == true &&
                                    json["results"]["shop"][i]["lat"].isEmpty == true &&
                                    json["results"]["shop"][i]["lng"].isEmpty == true &&
                                    json["results"]["shop"][i]["genre"]["name"].isEmpty == true &&
                                    json["results"]["shop"][i]["budget"]["average"].isEmpty == true &&
                                    json["results"]["shop"][i]["urls"]["pc"] != "" &&
                                    json["results"]["shop"][i]["name"] != "" &&
                                    json["results"]["shop"][i]["photo"]["mobile"]["l"] != "" &&
                                    json["results"]["shop"][i]["lunch"] != "" {
                                
                                print("daigo")
                                print(i)
                                
                                let shopData = ShopData(smallAreaName: json["results"]["shop"][i]["small_area"]["name"].string,
                                                        latitude: json["results"]["shop"][i]["lat"].double!,
                                                        longitude: json["results"]["shop"][i]["lng"].double!,
                                                        genreName: json["results"]["shop"][i]["genre"]["name"].string,
                                                        budgetAverage: json["results"]["shop"][i]["budget"]["average"].string,
                                                        name: json["results"]["shop"][i]["name"].string,
                                                        shop_image: json["results"]["shop"][i]["photo"]["mobile"]["l"].string,
                                                        url: json["results"]["shop"][i]["urls"]["pc"].string,
                                                        lunch: json["results"]["shop"][i]["lunch"].string)
                                
                                shopDataArray.append(shopData)
                                
                            }else{
                                print("何かしらが空です")
                            }
                            
                        }
                        
                        self.presenter.resultAPIData(shopDataArray: shopDataArray, idoValue: self.idoValue, keidoValue: self.keidoValue)

                    }else{
                        print("検索結果がありません")
                        self.presenter.resultAPIData(shopDataArray: shopDataArray, idoValue: self.idoValue, keidoValue: self.keidoValue)
                    }
                    
                }catch{
                    print("エラーです")
                    self.presenter.resultAPIData(shopDataArray: shopDataArray, idoValue: self.idoValue, keidoValue: self.keidoValue)
                }
                break
                
            case.failure:break
                self.presenter.resultAPIData(shopDataArray: shopDataArray, idoValue: self.idoValue, keidoValue: self.keidoValue)
            }
            
        }
        
    }
    
    
}
