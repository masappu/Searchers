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

protocol GourmandGenreAPIModelInput{
    
    //データを受け渡す変数
    var genreData:[GenreAPIModel] {get set}
    
    //データ取得のタイミングを依頼する
    func getGourmandGenreData(url:String, key:String)
    
}

protocol GourmandGenreAPIModelOutput{
    
    //依頼先に取得データを受け渡す
    func completedGourmandGenreData(data:[GenreAPIModel])
    
    //エラー
    func requestfailed(error:Error?)
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
        
        let urlString = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apikey)&lat=\(idoValue)&lng=\(keidoValue)&range=\(rangeCount + 1)&genre=\(genreString)&count=100&party_capacity=\(memberCount)&format=json"
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: ShopData.self) { [self] response in
            
            print(response.debugDescription)
            switch response.result{
                
            case.success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    var totalHitCount = json["results"]["results_available"].int
                    if totalHitCount! > rangeArray[rangeCount]{
                        totalHitCount = rangeArray[rangeCount]
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


struct GenreAPIModel{
    var name:String
    var id:String
    init(){
        self.name = String()
        self.id = String()
    }
}

final class GourmandGenreAPIModel:NSObject, GourmandGenreAPIModelInput{
    
    private var parser:XMLParser!
    private var presenter:GourmandGenreAPIModelOutput
    private var currentElement:String?
    
    var genreData: [GenreAPIModel] = []
    
    init(presenter:GourmandGenreAPIModelOutput){
        self.presenter = presenter
    }
    
    
    func getGourmandGenreData(url: String, key: String) {
        let urlString = url + key
        if let url = URL(string: urlString){
            if let parser = XMLParser(contentsOf: url){
                self.parser = parser
                self.parser.delegate = self
                self.genreData = []
//                self.parser.parse()
                guard self.parser.parse() else {
                    presenter.requestfailed(error: nil)
                    return
                }
            }
        }
    }
}

extension GourmandGenreAPIModel:XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "genre"{
            self.genreData.append(GenreAPIModel())
        }
        self.currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.genreData.count > 0{
            switch self.currentElement{
            case"code":
                self.genreData[self.genreData.count - 1].id = string
            case "name":
                self.genreData[self.genreData.count - 1].name = string
            default:break
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.presenter.completedGourmandGenreData(data: self.genreData)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.presenter.requestfailed(error: parseError)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        self.presenter.requestfailed(error: validationError)
    }
    
    
}

