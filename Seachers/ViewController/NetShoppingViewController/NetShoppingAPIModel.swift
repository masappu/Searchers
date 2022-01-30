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
    }

class NetShoppingAPIModel: NetShoppingAPIModelInput{
    
    var presenter:NetShoppingAPIModelOutput

    var urlString:String?
    var apikey = "1072027207911802205"
    var pageCount = Int()
    var productDataArray = [productData]()
    
  init(presenter:NetShoppingAPIModelOutput){
      self.presenter = presenter
    }
    //JSON解析を行う
    func setData(keyword:String){
        
        //urlエンコーディング
        let encordeUrlString:String = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?format=json&keyword=\(encordeUrlString)&sort=%2BitemPrice&applicationId=\(apikey)"

        print(urlString)
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { [self] (response) in

            print(response.debugDescription)
            
            switch response.result{
            
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    let totalHitCount = json["hits"].int
                    
                    for i in 0...totalHitCount! - 1{
                     
                        if json["Items"][i]["Item"]["itemName"] != "" && json["Items"][i]["Item"]["itemPrice"] != "" && json["Items"][i]["Item"]["itemUrl"] != "" &&  json["Items"][i]["Item"]["smallImageUrls"][0]["imageUrl"] != ""{

                            let productData = productData(
                                url: json["Items"][i]["Item"]["itemName"].string,
                                name: json["Items"][i]["Item"]["itemPrice"].string,
                                price: json["Items"][i]["Item"]["itemUrl"].int,
                                product_image: json["Items"][i]["Item"]["smallImageUrls"][0]["imageUrl"].string)
                        
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
