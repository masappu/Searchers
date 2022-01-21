//
//  MapPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/10.
//

import Foundation
import GoogleMaps
import RealmSwift
import CoreLocation


protocol MapPresenterInput {
    
    func loadMap(gourmandSearchData:GourmandSearchDataModel)
    func reloadMap(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int)
    func configureSubViews()
    func requestScrollViewDidEndDecelerating(x:Double,width:Double)
    func requestMapViewDidTap(marker:GMSMarker)
    func requestDoneButtonOfCategory(text: String)
    func addToFavoritesButton(indexPath:IndexPath)
    func goToWebVCButton(indexPath:IndexPath)
    
    var shopDataArray: [ShopDataDic]? {get set}
    var markers: [GMSMarker] {get set}
    var categoryArray: [String] {get set}
    var previousVcString:String {get set}
    var currentLocation:CLLocationCoordinate2D {get set}
    
}

protocol MapPresenterOutput {
    
    func setUpMap(idoValue:Double,keidoValue:Double)
    func setUpCollectionView()
    func setUpPickerView()
    func setUpSearchBar()
    func responseScrollViewDidEndDecelerating(marker: GMSMarker)
    func responseMapViewDidTap(marker: GMSMarker,index: Int)
    func responseDoneButtonOfCategory(rangeCount:Int)
    func addToFavorites(indexPath: IndexPath)
    func goToWebVC(url:String)
    
}

class MapPresenter: MapPresenterInput{
    
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var previousVcString: String
    var categoryArray: [String]
    var markers: [GMSMarker]
    var shopDataArray: [ShopDataDic]?
    
    private var view: MapPresenterOutput!
    private var gourmandAPIModel: GourmandAPIInput!
    private var travelAPIModel: TravelAPIInput!
    private var locationModel: LocaitonModelInput!
    
    init(view: MapViewController) {
        self.markers = []
        self.categoryArray = ["300", "500", "1000", "2000", "3000"]
        self.previousVcString = ""
        self.shopDataArray = []
        self.view = view
        let gourmandAPIModel = GourmandAPIModel(presenter: self)
        let locationModel = LocationModel(presenter: self)
        self.locationModel = locationModel
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
        let selectedShopData = shopDataArray![indexPath.row].value!
        let registeredFavShopData = realm.objects(favShopData.self).filter("name == '\(selectedShopData.name!)'")
        print(registeredFavShopData)
        let favShop = favShopData()
        
        if shopDataArray![indexPath.row].value?.favorite! == false{
            favShop.latitude = selectedShopData.latitude!
            favShop.longitude = selectedShopData.longitude!
            favShop.genreName = selectedShopData.genreName!
            favShop.budgetAverage = selectedShopData.budgetAverage!
            favShop.name = selectedShopData.name!
            favShop.shop_image = selectedShopData.shop_image!
            favShop.url = selectedShopData.url!
            favShop.lunch = selectedShopData.lunch!
            try! realm.write {
                realm.add(favShop)
            }
            shopDataArray![indexPath.row].value?.favorite! = true
            self.view.addToFavorites(indexPath: indexPath)
        }else{
            try! realm.write {
                realm.delete(registeredFavShopData)
            }
            shopDataArray![indexPath.row].value?.favorite! = false
            self.view.addToFavorites(indexPath: indexPath)
        }
    }
    
    func goToWebVCButton(indexPath: IndexPath) {
        let url = self.shopDataArray![indexPath.row].value?.url
        self.view.goToWebVC(url: url!)
    }
    
    func loadMap(gourmandSearchData:GourmandSearchDataModel) {
        gourmandAPIModel.setData(gourmandSearchData: gourmandSearchData, rangeCount: 3)
    }
    
    func reloadMap(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int) {
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
        let realm = try! Realm()
        let favShopData = realm.objects(favShopData.self)
        print(favShopData)
        self.shopDataArray = shopDataArray
        for shopDataDic in shopDataArray{
            makeMarker(shopData: shopDataDic.value!)
        }
        for favShop in favShopData{
            guard let index = self.shopDataArray!.firstIndex(where: { $0.key == favShop.name }) else{
                return
            }
            self.shopDataArray![index].value?.favorite = true
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

extension MapPresenter: LocaitonModelOutput{
    
    func completedRequestLocaiton(request: CLLocationCoordinate2D) {
        
    }
    
}
