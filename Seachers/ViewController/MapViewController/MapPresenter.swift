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
    
    func reloadData(goumandRange:String,travelRange:String)
    func configureSubViews()
    func requestScrollViewDidEndDecelerating(x:Double,width:Double)
    func requestMapViewDidTap(marker:GMSMarker)
    func addToFavoritesButton(indexPath:IndexPath)
    func goToWebVCButton(indexPath:IndexPath)
    
    var shopDataArray: [ShopDataToView] { get set }
    var travelDataArray: [travelDataToView] { get set }
    var markers: [GMSMarker] { get set }
    var categoryArray: [String] { get set }
    var zoomCount: Int { get set }
    var rangeCount: Int { get set }
    var currentLocation:CLLocationCoordinate2D { get set }
    var previousVCString:String { get set }
    var gourmandSearchData:GourmandSearchDataModel { get set }
    var travelSearchData: TravelSearchDataModel { get set }
    
}

protocol MapPresenterOutput {
    
    func setUpMap(idoValue:Double,keidoValue:Double)
    func setUpCollectionView()
    func setUpPickerView()
    func setUpSearchBar()
    func responseScrollViewDidEndDecelerating(marker: GMSMarker)
    func responseMapViewDidTap(marker: GMSMarker,index: Int)
    func setupSearchBarText()
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

struct travelDataToView{
    var travelData: HotelsData
    var favorite:Bool = false
    var favShop: String{
        switch favorite{
        case true: return "bookmark.fill"
        case false: return "bookmark"
        }
    }
}

enum CategoryType: String, CaseIterable{
    case gourmand = "GourmandSearchViewController"
    case travel = "TravelSearchViewController"

    var categoryArray: [String] {
        switch self {
        case .gourmand: return ["300m", "500m", "1000m", "2000m", "3000m"]
        case .travel: return ["1km","2km","3km"]
        }
    }
    var zoomArray: [Int] {
        switch self {
        case .gourmand: return [16,16,15,14,13]
        case .travel: return [15,15,15]
        }
    }
}

class MapPresenter: MapPresenterInput{
    
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var searchPlaceLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var categoryArray: [String] = []
    var zoomCount: Int = 15
    var rangeCount: Int = 2
    var markers: [GMSMarker] = []
    var shopDataArray: [ShopDataToView]
    var travelDataArray: [travelDataToView] = [travelDataToView]()
    var previousVCString: String = String()
    var gourmandSearchData: GourmandSearchDataModel = GourmandSearchDataModel()
    var travelSearchData: TravelSearchDataModel = TravelSearchDataModel()
    
    private var view: MapPresenterOutput!
    private var gourmandAPIModel: GourmandAPIInput!
    private var travelAPIModel: TravelAPIInput!
    private var locationModel: LocationModelInput!
    
    init(view: MapViewController) {
        self.shopDataArray = []
        self.view = view
        let gourmandAPIModel = GourmandAPIModel(presenter: self)
        let locationModel = LocationModel(presenter: self)
        let travelAPIModel = TravelAPIModel(presenter: self)
        self.travelAPIModel = travelAPIModel
        self.locationModel = locationModel
        self.gourmandAPIModel = gourmandAPIModel
    }
    
    func requestScrollViewDidEndDecelerating(x:Double,width:Double) {
        let indexCount = x / width
        let marker = markers[Int(indexCount)]
        self.view.responseScrollViewDidEndDecelerating(marker: marker)
    }
    
    func requestMapViewDidTap(marker:GMSMarker) {
        if previousVCString == "GourmandSearchViewController"{
            let index = (shopDataArray.firstIndex(where: { $0.shopData.name == marker.title }))!
            self.view.responseMapViewDidTap(marker: marker,index: index)
        }else{
            let index = (travelDataArray.firstIndex(where: { $0.travelData.hotelName == marker.title }))!
            self.view.responseMapViewDidTap(marker: marker,index: index)
        }
    }
    
    func addToFavoritesButton(indexPath:IndexPath){
        if previousVCString == "GourmandSearchViewController"{
            addToMapFavorites(indexPath:indexPath)
        }else{
            addToTravelFavorites(indexPath: indexPath)
        }
    }
    
    func goToWebVCButton(indexPath: IndexPath) {
        var url = String()
        if previousVCString == "GourmandSearchViewController"{
            url = self.shopDataArray[indexPath.row].shopData.url!
        }else{
            url = self.travelDataArray[indexPath.row].travelData.planListUrl
        }
        self.view.goToWebVC(url: url)
    }
    
    func reloadData(goumandRange:String,travelRange:String) {
        let categoryType = CategoryType(rawValue: previousVCString)
        self.categoryArray = categoryType!.categoryArray
        self.view.indicatorViewStart()
        self.markers = []
        if previousVCString == "GourmandSearchViewController"{
            self.shopDataArray = []
            self.rangeCount = self.categoryArray.firstIndex(of: "\(goumandRange)")!
            self.zoomCount = categoryType!.zoomArray[rangeCount]
            self.view.setupSearchBarText()
            gourmandAPIModel.setData(gourmandSearchData: self.gourmandSearchData, rangeCount: rangeCount)
        }else{
            self.travelDataArray = []
            self.rangeCount = self.categoryArray.firstIndex(of: "\(travelRange)")!
            self.zoomCount = categoryType!.zoomArray[rangeCount]
            self.view.setupSearchBarText()
            self.travelAPIModel.requestData(searchData: TravelSearchDataModel(), hits: 30, page: 1)
        }
    }
    
    func configureSubViews() {
        self.view.setUpSearchBar()
        self.view.setUpPickerView()
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
                self.shopDataArray.append(ShopDataToView(shopData: shopData))
                makeMarker(shopData: shopData)
            }
            for favShop in favShopData{
                if let index = self.shopDataArray.firstIndex(where: { $0.shopData.name == favShop.name }) {
                    self.shopDataArray[index].favorite = true
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
    
    func completedTravelAPIData(data: [HotelsData], pagingInfo: PagingInfo) {
        let realm = try! Realm()
        let favShopData = realm.objects(favHotelData.self)
        if data.isEmpty == true{
            self.view.setUpMap(idoValue:35.6809591,keidoValue:139.7673068)
            self.view.indicatorViewStop()
        }else{
            for item in data{
                self.travelDataArray.append(travelDataToView(travelData: item))
                makeMarker(shopData: item)
            }
            for favShop in favShopData{
                if let index = self.travelDataArray.firstIndex(where: { $0.travelData.hotelName == favShop.hotelName }) {
                    self.travelDataArray[index].favorite = true
                }
            }
            self.view.setUpMap(idoValue:35.6809591,keidoValue:139.7673068)
            self.view.indicatorViewStop()
        }
    }
    
    func requestfailed(error: Error) {
        print("エラー：\(error)")
    }
    
    func makeMarker(shopData:HotelsData) {
        print(shopData)
        let latitude = shopData.latitude
        let longitude = shopData.longitude
        let title = shopData.hotelName
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude,longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.title = "\(title)"
        marker.snippet = shopData.area + "/" + shopData.nearestStation
        markers.append(marker)
    }
    
}

extension MapPresenter: LocationModelOutput{
    
    func completedRequestLocaiton(request: CLLocationCoordinate2D) {
        
    }
    
}

extension MapPresenter{
    
    func addToMapFavorites(indexPath:IndexPath){
        let realm = try! Realm()
        let selectedShopData = shopDataArray[indexPath.row]
        
        let registeredFavShopData = realm.objects(favShopData.self).filter("name == '\(selectedShopData.shopData.name!)'")
        print(registeredFavShopData)
        let favShop = favShopData()
        
        if shopDataArray[indexPath.row].favorite == false{
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
            shopDataArray[indexPath.row].favorite = true
            self.view.addToFavorites(indexPath: indexPath)
        }else{
            try! realm.write {
                realm.delete(registeredFavShopData)
            }
            shopDataArray[indexPath.row].favorite = false
            self.view.addToFavorites(indexPath: indexPath)
        }
    }
    
    func addToTravelFavorites(indexPath:IndexPath){
        let realm = try! Realm()
        let selectedShopData = travelDataArray[indexPath.row]
        
        let registeredFavShopData = realm.objects(favHotelData.self).filter("hotelName == '\(selectedShopData.travelData.hotelName)'")
        let favHotel = favHotelData()
        
        if travelDataArray[indexPath.row].favorite == false{
            favHotel.hotelName = selectedShopData.travelData.hotelName
            favHotel.latitude = selectedShopData.travelData.latitude
            favHotel.longitude = selectedShopData.travelData.longitude
            favHotel.planListUrl = selectedShopData.travelData.planListUrl
            favHotel.hotelMinCharge = selectedShopData.travelData.hotelMinCharge
            favHotel.area = selectedShopData.travelData.area
            favHotel.nearestStation = selectedShopData.travelData.nearestStation
            favHotel.hotelImageUrl = selectedShopData.travelData.hotelImageUrl
            try! realm.write {
                realm.add(favHotel)
            }
            travelDataArray[indexPath.row].favorite = true
            self.view.addToFavorites(indexPath: indexPath)
        }else{
            try! realm.write {
                realm.delete(registeredFavShopData)
            }
            travelDataArray[indexPath.row].favorite = false
            self.view.addToFavorites(indexPath: indexPath)
        }
    }
    
}
