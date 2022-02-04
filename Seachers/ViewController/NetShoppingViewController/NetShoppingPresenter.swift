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
    func goToWebButton(indexPath:IndexPath)
    
    var productDataArray:[viewProductData] {get set}
}

protocol NetShoppingPresenterOutput{
    
    func setTableViewInfo()
    func reloadTableView()
    func setSearchBar()
    func addToFavorites(indexPath: IndexPath)
    func goToWeb(url: String)
    func showAlertResultEmpty()
    func showAlertError()
    
}

struct viewProductData{
    var NetShoppingData:newProductData
    var favorite:Bool
    var favProduct:String{
        switch self.favorite{
        case true:return "bookmark.fill"
        case false:return "bookmark"
        }
    }
}

class NetShoppingPresenter:NetShoppingPresenterInput{
    func addToFavoritesButton(indexPath:IndexPath) {
        let realm = try! Realm()
        let selectedProductData = productDataArray[indexPath.row]
        let registeredFavProductData = realm.objects(favProductData.self).filter("name == '\(selectedProductData.NetShoppingData.name)'")
        let favProduct = favProductData()
        
        if productDataArray[indexPath.row].favorite == false{
            favProduct.price = selectedProductData.NetShoppingData.price
            favProduct.name = selectedProductData.NetShoppingData.name
            favProduct.product_image = selectedProductData.NetShoppingData.product_image
            favProduct.url = selectedProductData.NetShoppingData.url
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
    
    func goToWebButton(indexPath:IndexPath) {
        let url = self.productDataArray[indexPath.row].NetShoppingData.url
        self.view.goToWeb(url: url)
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
        self.productDataArray = []
        model.setData(keyword: keyword)
    }
    
    func searchBarCancelButtonClicked() {
        
    }
    
    func searchBarShouldBeginEditing() {
        
    }
    
    
}

extension NetShoppingPresenter: NetShoppingAPIModelOutput{
    func requestFailed() {
        view.showAlertError()
    }
    
    
    
    func resultAPIData(productDataArray: [newProductData]) {
        
        for item in productDataArray{
            self.productDataArray.append(viewProductData(NetShoppingData: item, favorite: false))
        }
        
        //Realmのデータ取得
        let realm = try! Realm()
        let selectedItemDatas = realm.objects(favProductData.self)
        //productDataArrayと比較
        for item in selectedItemDatas{
            if let index = self.productDataArray.firstIndex(where: { $0.NetShoppingData.name == item.name}){
                self.productDataArray[index].favorite = true
            }
        }
        self.view.setTableViewInfo()
        self.view.reloadTableView()
    }
    func resultEmpty() {
        view.showAlertResultEmpty()
    }
    
    
}
