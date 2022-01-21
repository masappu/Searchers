//
//  NetShoppingViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit
import Alamofire
import SwiftyJSON

struct productData {
    
    var url:String?
    var name:String?
    var price:String?
    var product_image:String?
    
    
}

protocol DoneCatchDataProtocol {
    
    //規則を決める
    func catchData(arrayData:Array<productData>,resultCount:Int)
    
}

class NetShoppingViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var Label: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()

        // Do any additional setup after loading the view.
    }
    
    var urlString:String?
    var apikey = "e06e2a5afcf14b52139c1fb6c58e9dbc"
    var pageCount = Int()
    var urlArray = [String]()
    var imageStringArray = [String]()
    var nameStringArray = [String]()
    var priceIntArray = [Int]()
    var productDataArray = [productData]()
    var doneCatchDataProtocol:DoneCatchDataProtocol?
    
   
    
    //JSON解析を行う
    
    func setData(){
        
        //urlエンコーディング
        let encordeUrlString:String = urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { [self] (response) in

            print(response.debugDescription)
            
            switch response.result{
            
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    var totalHitCount = json["pageCount"].int
                    if totalHitCount! > 50{
                        totalHitCount = 50
                    }
                    
                    
                    for i in 0...pageCount - 1{
                     
                        if json["Products"][i]["minPrice"] != "" && json["Products"][i]["productName"] != "" && json["Products"][i]["productUrlMobile"] != "" && json["Products"][i]["name"] != "" && json["Products"][i]["smallImageUrl"] != ""{
                         
//                            let productData =  json["Products"][i]["minPrice"].int, name:json["Products"][i]["productName"].string , url: json["Products"][i]["productUrlMobile"].string, product_image: json["Products"][i]["smallImageUrl"].string)
                        
                          //  self.productDataArray.append(productData)
                            print(self.productDataArray.debugDescription)
                            
                        }else{
                            
                            print("何かしらが空です")
                            
                        }
                        
                        
                    }
                    
                    
                    self.doneCatchDataProtocol?.catchData(arrayData: self.productDataArray, resultCount: self.productDataArray.count)
                    
                }catch{
                    
                    print("エラーです")
                }
            break
                
            case .failure:break
            
            }
        
        }
        
        
    }
    
    //検索バーの設置
    func setSearchBar() {
        // NavigationBarにSearchBarをセット
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            //NavigationBarに適したサイズの検索バーを設置
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            //デリゲート
            searchBar.delegate = self
            //プレースホルダー
            searchBar.placeholder = "ユーザーを検索"
            //検索バーのスタイル
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            //NavigationTitleが置かれる場所に検索バーを設置
            navigationItem.titleView = searchBar
            //NavigationTitleのサイズを検索バーと同じにする
            navigationItem.titleView?.frame = searchBar.frame
        }
    }
    
    //検索バーで入力する時
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //キャンセルボタンを表示
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    //検索バーのキャンセルがタップされた時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //キャンセルボタンを非表示
        searchBar.showsCancelButton = false
        //キーボードを閉じる
        searchBar.resignFirstResponder()
    }
    
    
    //検索バーでEnterが押された時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Labelに入力した値を設定
        Label.text = searchBar.text as! String
        
        let urlString = "https://app.rakuten.co.jp/services/api/Product/Search/20170426?format=json&keyword=\(searchBar.text)&applicationId=\(apikey)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
