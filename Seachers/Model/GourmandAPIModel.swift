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
    func setData()
}

protocol GourmandAPIOutput{
    func resultAPIData(shopDataArray: [ShopDataDic])
}

struct HTTPResponse: Decodable {
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

struct ShopData {
    
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

struct ShopDataDic{
    
    var key:String?
    var value:ShopData?
    
}

class GourmandAPIModel: GourmandAPIInput{
    
    
    var presenter:GourmandAPIOutput
    var apikey = "28d7568c4dcea09f"
    var idoValue = Double()
    var keidoValue = Double()
    var rangeCount = Int()
    var memberCount = Int()
    var shopDataArray = [ShopDataDic]()
    
    init(presenter:GourmandAPIOutput){
        self.presenter = presenter
    }
    
    //JSON解析を行う
    func setData(){
        
        idoValue = 35.6954496
        keidoValue = 139.7514154
        rangeCount = 2
        memberCount = 2
        
        //urlエンコーディング
        let urlString = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apikey)&lat=\(idoValue)&lng=\(keidoValue)&range=\(rangeCount)&count=50&party_capacity=\(memberCount)&format=json"
//        let encodeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: HTTPResponse.self) { [self] response in

            
            print(response.debugDescription)
            switch response.result{
            
            case.success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    var totalHitCount = json["results"]["results_available"].int
                    print("totalHitcount")
                    print(totalHitCount)
                        if totalHitCount! > 50{
                            totalHitCount = 50
                        }
                    
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

                            let shopData = ShopData(smallAreaName: json["results"]["shop"][i]["small_area"]["name"].string,
                                                    latitude: json["results"]["shop"][i]["lat"].double!,
                                                    longitude: json["results"]["shop"][i]["lng"].double!,
                                                    genreName: json["results"]["shop"][i]["genre"]["name"].string,
                                                    budgetAverage: json["results"]["shop"][i]["budget"]["average"].string,
                                                    name: json["results"]["shop"][i]["name"].string,
                                                    shop_image: json["results"]["shop"][i]["photo"]["mobile"]["l"].string,
                                                    url: json["results"]["shop"][i]["urls"]["pc"].string,
                                                    lunch: json["results"]["shop"][i]["lunch"].string)
                            
                            shopDataArray.append(ShopDataDic(key: json["results"]["shop"][i]["name"].string!, value: shopData))
                            print(self.shopDataArray.debugDescription)
                            
                        }else{
                            print("何かしらが空です")
                        }
                    }
                    self.presenter.resultAPIData(shopDataArray: shopDataArray)
                    
                }catch{
                    print("エラーです")
                }
                break
            
            case.failure:break
                
            }
            
            
            
        }
        
        
    }
    
    
}
