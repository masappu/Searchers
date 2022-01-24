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
    
    var shopDataArray: [ShopDataToView]? {get set}
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
    func indicatorViewStart()
    func indicatorViewStop()
    
}

struct ShopDataToView {
    var shopData: ShopData
    var favorite:Bool = false
    var favShop:String{
        switch favorite{
        case true: return "bookmark.fill"
        case false: return "bookmark"
        }
    }
}

class MapPresenter: MapPresenterInput{
    
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var previousVcString: String = ""
    var categoryArray: [String] = ["300", "500", "1000", "2000", "3000"]
    var markers: [GMSMarker] = []
    var shopDataArray: [ShopDataToView]?
    
    private var view: MapPresenterOutput!
    private var gourmandAPIModel: GourmandAPIInput!
    private var travelAPIModel: TravelAPIInput!
    private var locationModel: LocationModelInput!
    
    init(view: MapViewController) {
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
        let index = shopDataArray?.firstIndex(where: { $0.shopData.name == marker.title })
        self.view.responseMapViewDidTap(marker: marker,index: index!)
    }
    
    func requestDoneButtonOfCategory(text: String) {
        let rangeCount = categoryArray.firstIndex(of: "\(text)")! + 1
        self.view.responseDoneButtonOfCategory(rangeCount: rangeCount)
    }
    
    func addToFavoritesButton(indexPath:IndexPath){
        let realm = try! Realm()
        let selectedShopData = shopDataArray![indexPath.row]
        let registeredFavShopData = realm.objects(favShopData.self).filter("name == '\(selectedShopData.shopData.name!)'")
        print(registeredFavShopData)
        let favShop = favShopData()
        
        if shopDataArray![indexPath.row].favorite == false{
            favShop.latitude = selectedShopData.shopData.latitude!
            favShop.longitude = selectedShopData.shopData.longitude!
            favShop.smallAreaName = selectedShopData.shopData.smallAreaName!
            favShop.genreName = selectedShopData.shopData.genreName!
            favShop.budgetAverage = selectedShopData.shopData.budgetAverage!
            favShop.name = selectedShopData.shopData.name!
            favShop.shop_image = selectedShopData.shopData.shop_image!
            favShop.url = selectedShopData.shopData.url!
            favShop.lunch = selectedShopData.shopData.lunch!
            try! realm.write {
                realm.add(favShop)
            }
            shopDataArray![indexPath.row].favorite = true
            self.view.addToFavorites(indexPath: indexPath)
        }else{
            try! realm.write {
                realm.delete(registeredFavShopData)
            }
            shopDataArray![indexPath.row].favorite = false
            self.view.addToFavorites(indexPath: indexPath)
        }
    }
    
    func goToWebVCButton(indexPath: IndexPath) {
        let url = self.shopDataArray![indexPath.row].shopData.url
        self.view.goToWebVC(url: url!)
    }
    
    func loadMap(gourmandSearchData:GourmandSearchDataModel) {
        self.view.indicatorViewStart()
        gourmandAPIModel.setData(gourmandSearchData: gourmandSearchData, rangeCount: 3)
    }
    
    func reloadMap(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int) {
        self.view.indicatorViewStart()
        self.shopDataArray = []
        self.markers = []
        
        gourmandAPIModel.setData(gourmandSearchData: gourmandSearchData, rangeCount: rangeCount)
    }
    
    func configureSubViews() {
        self.view.setUpPickerView()
        self.view.setUpSearchBar()
        self.view.setUpCollectionView()
    }
    
}

extension MapPresenter: GourmandAPIOutput{
    
    func resultAPIData(shopDataArray: [ShopData], idoValue: Double, keidoValue: Double) {
        let realm = try! Realm()
        let favShopData = realm.objects(favShopData.self)
        print(shopDataArray.count)
        if shopDataArray.isEmpty == true{
            self.view.setUpMap(idoValue:idoValue,keidoValue:keidoValue)
            self.view.indicatorViewStop()
        }else{
            for shopData in shopDataArray{
                self.shopDataArray?.append(ShopDataToView(shopData: shopData))
                makeMarker(shopData: shopData)
            }
            for favShop in favShopData{
                if let index = self.shopDataArray!.firstIndex(where: { $0.shopData.name == favShop.name }) {
                    self.shopDataArray![index].favorite = true
                }
            }
            self.view.setUpMap(idoValue:idoValue,keidoValue:keidoValue)
            self.view.indicatorViewStop()
        }
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

extension MapPresenter: LocationModelOutput{
    
    func completedRequestLocaiton(request: CLLocationCoordinate2D) {
        
    }
    
}
