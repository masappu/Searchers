//
//  NetShoppingPresenter.swift
//  Seachers
//
//  Created by 西林遼太郎 on 2022/01/22.
//

import Foundation

protocol NetShoppingPresenterInput{
    
  
    func viewWillApper()
    func searchBarSearchButtonClicked(keyword:String)
    func searchBarCancelButtonClicked()
    func searchBarShouldBeginEditing()
//    func addToFavoritesButton()
//    func goToWebBotton()
    
    var productDataArray:[productData] {get set}
}

protocol NetShoppingPresenterOutput{
    
    func setTableViewInfo()
    func reloadTableView()
    func setSearchBar()
    
    
}

class NetShoppingPresenter:NetShoppingPresenterInput{
//    func addToFavoritesButton() {
//        let realm = try! Realm()
//        let selectedProductData = productDataArray![indexPath.row]
//        let registeredFavProductData = realm.objects(favProductData.self).filter("name == '\(selectedProductData.name!)'")
//        let favProduct = favProductData()
//
//        if productDataArray![indexPath.row].favorite! == false{
//            favProduct.price = selectedProductData.price!
//            favProduct.name = selectedProductData.name!
//            favProduct.product_image = selectedProductData.shop_image!
//            favProduct.url = selectedProductData.url!
//            try! realm.write {
//                realm.add(favProduct)
//            }
//            productDataArray![indexPath.row].favorite! = true
//            self.view.addToFavorites(indexPath: indexPath)
//        }else{
//            try! realm.write {
//                realm.delete(registeredFavProductData)
//            }
//            productDataArray![indexPath.row].favorite! = false
//            self.view.addToFavorites(indexPath: indexPath)
//        }
//    }
//
//    func goToWebBotton() {
//        let url = self.productDataArray![indexPath.row].url
//        self.view.goToWebVC(url: url!)
//    }
    
    
    
    var productDataArray: [productData]
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
        self.productDataArray = productDataArray
        
        self.view.reloadTableView()
    }
    
}
