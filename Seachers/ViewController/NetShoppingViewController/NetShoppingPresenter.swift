//
//  NetShoppingPresenter.swift
//  Seachers
//
//  Created by 西林遼太郎 on 2022/01/22.
//

import Foundation
import RealmSwift

protocol NetShoppingPresenterInput{
    
  
    func viewWillApper()
    func searchBarSearchButtonClicked(keyword:String)
    func searchBarCancelButtonClicked()
    func searchBarShouldBeginEditing()
    func addToFavoritesButton(indexPath:IndexPath)
    func goToWebBotton(indexPath:IndexPath)
    
    var productDataArray:[viewProductData] {get set}
}

protocol NetShoppingPresenterOutput{
    
    func setTableViewInfo()
    func reloadTableView()
    func setSearchBar()
    func addToFavorites(indexPath: IndexPath)
    func goToWeb(url: String)
    
}

struct viewProductData{
    var NetShoppingData:productData
    var favorite:Bool
    var favProduct:String{
        switch self.favorite{
        case true:return "bookmark.fill"
        case false:return "bookmark"
        }
    }
    
    init(){
        self.NetShoppingData = productData()
        self.favorite = false
    }
}

class NetShoppingPresenter:NetShoppingPresenterInput{
        func addToFavoritesButton(indexPath:IndexPath) {
            let realm = try! Realm()
            let selectedProductData = productDataArray[indexPath.row]
            let registeredFavProductData = realm.objects(favProductData.self).filter("name == '\(selectedProductData.NetShoppingData.name!)'")
            let favProduct = favProductData()
    
            if productDataArray[indexPath.row].favorite == false{
                favProduct.price = selectedProductData.NetShoppingData.price!
                favProduct.name = selectedProductData.NetShoppingData.name!
                favProduct.product_image = selectedProductData.NetShoppingData.product_image!
                favProduct.url = selectedProductData.NetShoppingData.url!
                try! realm.write {
                    realm.add(favProduct)
                }
                productDataArray[indexPath.row].favorite = true
                self.view.addToFavorites(indexPath: indexPath)
            }else{
                try! realm.write {
                    realm.delete(registeredFavProductData)
                }
                productDataArray[indexPath.row].favorite = false
                self.view.addToFavorites(indexPath: indexPath)
            }
        }
    
    func goToWebBotton(indexPath:IndexPath) {
        let url = self.productDataArray[indexPath.row].NetShoppingData.url
            self.view.goToWeb(url: url!)
        }
    
    
    
    var productDataArray: [viewProductData]
    var view: NetShoppingPresenterOutput!
    var model: NetShoppingAPIModelInput!
    var cheapProduct = String()
    
    init(view: NetShoppingViewController){
        
        self.productDataArray = []
        self.view = view
        let model = NetShoppingAPIModel(presenter:self)
        self.model = model
    }
    
 
    func viewWillApper(){
        self.view.setSearchBar()
    }
    
    func searchBarSearchButtonClicked(keyword:String) {
        model.setData(keyword: keyword)
    }
    
    func searchBarCancelButtonClicked() {
        
    }
    
    func searchBarShouldBeginEditing() {
        
    }
   
    
  

    
}

extension NetShoppingPresenter: NetShoppingAPIModelOutput{
    
    func resultAPIData(productDataArray: [productData]) {
        
        for item in productDataArray{
            var newItem = viewProductData()
            newItem.NetShoppingData = item
            self.productDataArray.append(newItem)
        }
        //Realmのデータ取得
        //productDataArrayと比較
        //Bool値をtrueに変更
        self.view.setTableViewInfo()
        self.view.reloadTableView()
        
       var newData = productDataArray
       print(newData)
//        newData.sort{$0.price! < $1.price!}
    }
    
}
