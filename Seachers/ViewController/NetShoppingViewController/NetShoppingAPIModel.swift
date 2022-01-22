//
//  NetShoppingAPIModel.swift
//  Seachers
//
//  Created by 西林遼太郎 on 2022/01/21.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetShoppingAPIModelInput{
    func setData(keyword:String)
    
    var productDataArray:[productData] {get set}
    
}

protocol NetShoppingAPIModelOutput{
    func resultAPIData(productDataArray:[productData])
}

struct productData {
    
    var url:String?
    var name:String?
    var price:Int?
    var product_image:String?
    var favorite:Bool?
    
}

class NetShoppingAPIModel: NetShoppingAPIModelInput{
    
    var presenter:NetShoppingAPIModelOutput

    var urlString:String?
//    var apikey = "e06e2a5afcf14b52139c1fb6c58e9dbc"
    var apikey = "1072027207911802205"
    var pageCount = Int()
//    var urlArray = [String]()
//    var imageStringArray = [String]()
//    var nameStringArray = [String]()
//    var priceIntArray = [Int]()
    var productDataArray = [productData]()
//    var keywordString = String()

    
  init(presenter:NetShoppingAPIModelOutput){
      self.presenter = presenter
    }
    
    //JSON解析を行う
    
    func setData(keyword:String){
        
        //urlエンコーディング
        
        let urlString = "https://app.rakuten.co.jp/services/api/Product/Search/20170426?format=json&keyword=\(keyword)&applicationId=\(apikey)"
        
        let encordeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { [self] (response) in

            print(response.debugDescription)
            
            switch response.result{
            
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    var totalHitCount = json["count"].int
                    if totalHitCount! > 50{
                        totalHitCount = 50
                    }
                    
                    
                    for i in 0...totalHitCount! - 1{
                     
                        if json["Products"][i]["Product"]["minPrice"] != "" && json["Products"][i]["Product"]["productName"] != "" && json["Products"][i]["Product"]["productUrlMobile"] != "" &&  json["Products"][i]["Product"]["smallImageUrl"] != ""{

                            
                            let productData = productData(url: json["Products"][i]["Product"]["productUrlMobile"].string,
                                                          name: json["Products"][i]["Product"]["productUrlMobile"].string,
                                                          price: json["Products"][i]["Product"]["minPrice"].int,
                                                          product_image: json["Products"][i]["Product"]["smallImageUrl"].string)
                            

                              self.productDataArray.append(productData)
                            print(self.productDataArray.debugDescription)
                            
                        }else{
                            
                            print("何かしらが空です")
                            
                        }
                    }
                    self.presenter.resultAPIData(productDataArray: productDataArray)
                    
                }catch{
                    
                    print("エラーです")
                }
            break
                
            case .failure:break
            
            }
        
        }
        

}
}
