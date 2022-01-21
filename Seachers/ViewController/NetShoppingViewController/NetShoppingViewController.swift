//
//  NetShoppingViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit
import Alamofire
import SwiftyJSON



protocol DoneCatchDataProtocol {
    
    //規則を決める
    func catchData(arrayData:Array<productData>,resultCount:Int)
    
}

class NetShoppingViewController: UIViewController,UISearchBarDelegate,NetShoppingAPIModelOutput {

    @IBOutlet weak var Label: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()

        // Do any additional setup after loading the view.
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
            searchBar.placeholder = "商品を検索"
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
