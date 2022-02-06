//
//  FavOfNetShoppingPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/24.
//

import Foundation
import RealmSwift

protocol FavOfNetShoppingPresenterInput{
    
    func viewwillAppear(didSelectCell indexPath:IndexPath?)
    func deleteCellButton(indexPath:IndexPath)
    func didSelectRowAt(indexPath: IndexPath)
    
    var favProductDataArray: [favProductData] {get set}
}

protocol FavOfNetShoppingPresenterOutput{
    
    func setupTableView()
    func reloadTableView()
    func deleteFavProduct(indexPath:IndexPath)
    func goToWebVC(url:String)
    func highlightDelete(indexPath:IndexPath)
    
}

class FavOfNetShoppingPresenter: FavOfNetShoppingPresenterInput{
    
    var favProductDataArray: [favProductData] = []
    private var view:FavOfNetShoppingPresenterOutput!
    
    init(view:FavOfNetShoppingViewController){
        self.view = view
    }
    
    func viewwillAppear(didSelectCell indexPath:IndexPath?) {
        if let selectRow = indexPath{
            self.view.highlightDelete(indexPath: selectRow)
        }
        let realm = try! Realm()
        let favProductData = realm.objects(favProductData.self)
        for item in favProductData{
            self.favProductDataArray.append(item)
        }
        self.view.setupTableView()
    }
    
    func deleteCellButton(indexPath: IndexPath) {
        let realm = try! Realm()
        let selectedProductData = favProductDataArray[indexPath.row]
        
        let registeredFavProductData = realm.objects(favProductData.self).filter("name == '\(selectedProductData.name)'")
        
        self.favProductDataArray.remove(at: indexPath.row)
        try! realm.write {
            realm.delete(registeredFavProductData)
        }
        
        self.view.deleteFavProduct(indexPath: indexPath)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let url = self.favProductDataArray[indexPath.row].url
        self.view.goToWebVC(url: url)
    }
    
    
}
