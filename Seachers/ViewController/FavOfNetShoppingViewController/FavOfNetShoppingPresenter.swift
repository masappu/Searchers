//
//  FavOfNetShoppingPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/24.
//

import Foundation
import RealmSwift

protocol FavOfNetShoppingPresenterInput{
    
    func viewwillAppear()
    func deleteCellButton(indexPath:IndexPath)
    func didSelectRowAt(indexPath: IndexPath)
    
    //↓Realm出来次第型を変更してください
    var favShopDataArray: [favShopData] {get set}
    //↑Realm出来次第型を変更してください
    
}

protocol FavOfNetShoppingPresenterOutput{
    
    func setupTableView()
    func reloadTableView()
    func deleteFavShop(indexPath:IndexPath)
    func goToWebVC(url:String)
    
}

class FavOfNetShoppingPresenter: FavOfNetShoppingPresenterInput{
    
    var favShopDataArray: [favShopData] = []
    private var view:FavOfNetShoppingPresenterOutput!
    
    init(view:FavOfNetShoppingViewController){
        self.view = view
    }
    
    func viewwillAppear() {
        let realm = try! Realm()
        let favShopData = realm.objects(favShopData.self)
        for favShop in favShopData{
            self.favShopDataArray.append(favShop)
        }
        self.view.setupTableView()
    }
    
    func deleteCellButton(indexPath: IndexPath) {
        let realm = try! Realm()
        let selectedShopData = favShopDataArray[indexPath.row]
        
        //↓Realm出来次第型を変更してください
        let registeredFavShopData = realm.objects(favShopData.self).filter("name == '\(selectedShopData.name)'")
        //↑Realm出来次第型を変更してください
        
        self.favShopDataArray.remove(at: indexPath.row)
        try! realm.write {
            realm.delete(registeredFavShopData)
        }
        
        self.view.deleteFavShop(indexPath: indexPath)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let url = self.favShopDataArray[indexPath.row].url
        self.view.goToWebVC(url: url)
    }
    
    
}
