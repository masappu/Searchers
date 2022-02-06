//
//  FavOfGourmandPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/24.
//

import Foundation
import RealmSwift

protocol FavOfGourmandPresenterInput{
    
    func viewwillAppear(didSelectCell indexPath:IndexPath?)
    func deleteCellButton(indexPath:IndexPath)
    func didSelectRowAt(indexPath: IndexPath)
    
    var favShopDataArray: [favShopData] {get set}
    
}

protocol FavOfGourmandPresenterOutput{
    
    func setupTableView()
    func reloadTableView()
    func deleteFavShop(indexPath:IndexPath)
    func goToWebVC(url:String)
    func highlightDelete(indexPath:IndexPath)
    
}

class FavOfGourmandPresenter: FavOfGourmandPresenterInput{
    
    var favShopDataArray: [favShopData] = []
    private var view:FavOfGourmandPresenterOutput!
    
    init(view:FavOfGourmandViewController){
        self.view = view
    }
    
    func viewwillAppear(didSelectCell indexPath:IndexPath?) {
        if let selectRow = indexPath{
            self.view.highlightDelete(indexPath: selectRow)
        }
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
        let registeredFavShopData = realm.objects(favShopData.self).filter("name == '\(selectedShopData.name)'")
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
