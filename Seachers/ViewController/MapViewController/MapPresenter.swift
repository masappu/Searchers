//
//  MapPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/10.
//

import Foundation
import GoogleMaps
import RealmSwift


protocol MapPresenterInput {
    
    func loadMap(gourmandSearchData:GourmandSearchDataModel)
    func reloadMap(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int)
    func configureSubViews()
    func requestScrollViewDidEndDecelerating(x:Double,width:Double)
    func requestMapViewDidTap(marker:GMSMarker)
    func requestDoneButtonOfCategory(text: String)
    func addToFavoritesButton(indexPath:IndexPath)
    
    var shopDataArray: [ShopDataDic]? {get set}
    var markers: [GMSMarker] {get set}
    var categoryArray: [String] {get set}
    
}

protocol MapPresenterOutput {
    
    func setUpMap(idoValue:Double,keidoValue:Double)
    func setUpLocationManager()
    func setUpCollectionView()
    func setUpPickerView()
    func setUpSearchBar()
    func responseScrollViewDidEndDecelerating(marker: GMSMarker)
    func responseMapViewDidTap(marker: GMSMarker,index: Int)
    func responseDoneButtonOfCategory(rangeCount:Int)
    func addToFavorites(indexPath: IndexPath)
    
}

class MapPresenter: MapPresenterInput{
    

    var categoryArray: [String]
    var markers: [GMSMarker]
    var shopDataArray: [ShopDataDic]?
    
    private var view: MapPresenterOutput!
    private var gourmandAPIModel: GourmandAPIInput!
    private var travelAPIModel: TravelAPIInput!
    
    init(view: MapViewController) {
        self.markers = []
        self.categoryArray = ["300", "500", "1000", "2000", "3000"]
        self.view = view
        let gourmandAPIModel = GourmandAPIModel(presenter: self)
        self.gourmandAPIModel = gourmandAPIModel
        self.travelAPIModel = TravelAPIModel()
    }
    
    func requestScrollViewDidEndDecelerating(x:Double,width:Double) {
        let indexCount = x / width
        let marker = markers[Int(indexCount)]
        self.view.responseScrollViewDidEndDecelerating(marker: marker)
    }
    
    func requestMapViewDidTap(marker:GMSMarker) {
        let index = shopDataArray?.firstIndex(where: { $0.key == marker.title })
        self.view.responseMapViewDidTap(marker: marker,index: index!)
    }
    
    func requestDoneButtonOfCategory(text: String) {
        let rangeCount = categoryArray.firstIndex(of: "\(text)")! + 1
        self.view.responseDoneButtonOfCategory(rangeCount: rangeCount)
    }
    
    func addToFavoritesButton(indexPath:IndexPath){
        let realm = try! Realm()
        let favShopData = realm.objects(favShopData.self)
//        let favShop = favShopData()
        self.view.addToFavorites(indexPath: indexPath)
    }
    
    func loadMap(gourmandSearchData:GourmandSearchDataModel) {
        self.view.setUpLocationManager()
        gourmandAPIModel.setData(gourmandSearchData: gourmandSearchData, rangeCount: 3)
    }
    
    func reloadMap(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int) {
        self.view.setUpLocationManager()
        gourmandAPIModel.setData(gourmandSearchData: gourmandSearchData, rangeCount: rangeCount)
    }
    
    func configureSubViews() {
        self.view.setUpPickerView()
        self.view.setUpSearchBar()
        self.view.setUpCollectionView()
    }
    
}

extension MapPresenter: GourmandAPIOutput{
    
    func resultAPIData(shopDataArray: [ShopDataDic], idoValue: Double, keidoValue: Double) {
        
        self.shopDataArray = shopDataArray
        for shopDataDic in shopDataArray{
            makeMarker(shopData: shopDataDic.value!)
        }
        self.view.setUpMap(idoValue:idoValue,keidoValue:keidoValue)
    }
    
    func makeMarker(shopData:ShopData) {
        let latitude = shopData.latitude!
        let longitude = shopData.longitude!
        let title = shopData.name!
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude,longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.title = "\(title)"
        marker.snippet = shopData.smallAreaName! + "/" + shopData.genreName!
        markers.append(marker)
    }
    
}

extension MapPresenter: TravelAPIOutput{
    
    
    
}
