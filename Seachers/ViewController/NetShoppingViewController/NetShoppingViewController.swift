//
//  NetShoppingViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit
import Alamofire
import SwiftyJSON

struct ShopData {
    
    var url:String?
    var name:String?
    var price:String?
    var product_image:String?
    
    
}

protocol DoneCatchDataProtocol {
    
    //規則を決める
    func catchData(arrayData:Array<ShopData>,resultCount:Int)
    
}

class NetShoppingViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()

        // Do any additional setup after loading the view.
    }
    
    var urlString:String?
    var shopDataArray = [ShopData]()
    var doneCatchDataProtocol:DoneCatchDataProtocol?
    
    //ViewControllerから値を受け取る
    init(url:String){
        
        urlString = url

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //JSON解析を行う
    
    func setData(){
        
        //urlエンコーディング
        let encordeUrlString:String = urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in

            print(response.debugDescription)
            
            switch response.result{
            
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    var totalHitCount = json["total_hit_count"].int
                    if totalHitCount! > 50{
                        totalHitCount = 50
                    }
                    
                    
                    for i in 0...totalHitCount! - 1{
                     
                        if json["rest"][i]["latitude"] != "" && json["rest"][i]["longitude"] != "" && json["rest"][i]["url"] != "" && json["rest"][i]["name"] != "" && json["rest"][i]["tel"] != "" && json["rest"][i]["image_url"]["shop_image1"] != ""{
                         
                            let shopData =  json["rest"][i]["url"].string, name:json["rest"][i]["name"].string , tel: json["rest"][i]["tel"].string, shop_image: json["rest"][i]["image_url"]["shop_image1"].string)
                        
                            self.shopDataArray.append(shopData)
                            print(self.shopDataArray.debugDescription)
                            
                        }else{
                            
                            print("何かしらが空です")
                            
                        }
                        
                        
                    }
                    
                    
                    self.doneCatchDataProtocol?.catchData(arrayData: self.shopDataArray, resultCount: self.shopDataArray.count)
                    
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
