//
//  FavOfTravelPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/24.
//

import Foundation
import RealmSwift

protocol FavOfTravelPresenterInput{
    
    func viewwillAppear(didSelectCell indexPath:IndexPath?)
    func deleteCellButton(indexPath:IndexPath)
    func didSelectRowAt(indexPath: IndexPath)
    
    var favShopDataArray: [favHotelData] {get set}
    var rgb: color{get}
    
}

protocol FavOfTravelPresenterOutput{
    
    func setupTableView()
    func reloadTableView()
    func deleteFavShop(indexPath:IndexPath)
    func goToWebVC(url:String)
    func highlightDelete(indexPath:IndexPath)
}

class FavOfTravelPresenter: FavOfTravelPresenterInput{
    
    var rgb: color = ColorType(rawValue: "Travel")!.rgb
    var favShopDataArray: [favHotelData] = []
    private var view:FavOfTravelPresenterOutput!
    
    init(view:FavOfTravelViewController){
        self.view = view
    }
    
    func viewwillAppear(didSelectCell indexPath:IndexPath?) {
        if let selectRow = indexPath{
            self.view.highlightDelete(indexPath: selectRow)
        }
        let realm = try! Realm()
        let favShopData = realm.objects(favHotelData.self)
        for favShop in favShopData{
            self.favShopDataArray.append(favShop)
        }
        self.view.setupTableView()
    }
    
    func deleteCellButton(indexPath: IndexPath) {
        let realm = try! Realm()
        let selectedShopData = favShopDataArray[indexPath.row]
        
        let registeredFavShopData = realm.objects(favHotelData.self).filter("hotelName == '\(selectedShopData.hotelName)'")
        
        self.favShopDataArray.remove(at: indexPath.row)
        try! realm.write {
            realm.delete(registeredFavShopData)
        }
        
        self.view.deleteFavShop(indexPath: indexPath)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let url = self.favShopDataArray[indexPath.row].planListUrl
        self.view.goToWebVC(url: url)
    }
    
    
}
