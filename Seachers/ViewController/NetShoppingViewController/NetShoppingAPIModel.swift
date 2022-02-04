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
    func resultAPIData(productDataArray:[newProductData])
    func resultEmpty()
    func requestFailed()
}

struct productData: Decodable {
    
    var url:String?
    var name:String?
    var price:Int?
    var product_image:String?
    var valuaiton:Double?
    
}

struct newProductData{
    
    var url = String()
    var name = String()
    var price = String()
    var product_image = String()
    var valuation = String()
    
    init(origin data:productData){
        
        if data.price == nil{
            self.price = "-"
        }else{
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            self.price = "\(formatter.string(from: NSNumber(value: data.price!)) ?? "-")"
        }
        
        if data.url == nil{
            self.url = "-"
        }else{
            self.url = data.url!
        }
        
        if data.name == nil{
            self.name = "-"
        }else{
            self.name = data.name!
        }
        
        if data.valuaiton == nil{
            self.valuation = "-"
        }else{
            self.valuation = String(data.valuaiton!)
        }
        
        if data.product_image == nil{
            self.product_image = "http://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png"
        }else{
            self.product_image = data.product_image!
        }
    }
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
        let urlString = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?format=json&keyword=\(encordeUrlString)&applicationId=\(apikey)"
        
        print(urlString)
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: productData.self) { [self] response in
            
            print(response.debugDescription)
            
            switch response.result{
                
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    var passData:[newProductData] = []
                    let totalHitCount = json["hits"].int
                    if totalHitCount == 0{
                        presenter.resultEmpty()
                        
                        return
                    }
                    
                    for i in 0...totalHitCount! - 1{
                        if json["Items"][i]["Item"]["itemName"] != "" && json["Items"][i]["Item"]["itemPrice"] != "" && json["Items"][i]["Item"]["itemUrl"] != "" &&
                            json["Item"][i]["Item"]["reviewAverage"] != "" &&
                            json["Items"][i]["Item"]["mediumImageUrls"][0]["imageUrl"] != "" && json["Items"][i]["Item"]["reviewAverage"] != ""{
                          
                        let productData = productData(
                                url: json["Items"][i]["Item"]["itemUrl"].string,
                                name: json["Items"][i]["Item"]["itemName"].string,
                                price: json["Items"][i]["Item"]["itemPrice"].int,
                                product_image: json["Items"][i]["Item"]["mediumImageUrls"][0]["imageUrl"].string,
                                valuaiton: json["Items"][i]["Item"]["reviewAverage"].double)
                                
                                let newData = newProductData(origin: productData)
                                passData.append(newData)
                        }else{
                            print("何かしらが空です")
                        }
                    }
                    self.presenter.resultAPIData(productDataArray: passData)
                    
                }catch{
                    print("エラーです")
                }
                break
                
            case .failure:
                presenter.requestFailed()
                break
                
            }
        }
    }
}

