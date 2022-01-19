//
//  MapPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/10.
//

import Foundation


protocol MapPresenterInput {
    
    func loadMap(gourmandSearchData:GourmandSearchDataModel)
    func reloadMap(gourmandSearchData:GourmandSearchDataModel,rangeCount:Int)
    func configureSubViews()
    var shopDataArray: [ShopDataDic]? {get set}
    
}

protocol MapPresenterOutput {
    
    func setUpMap(idoValue:Double,keidoValue:Double)
    func setUpLocationManager()
    func setUpCollectionView()
    func setUpPickerView()
    func setUpSearchBar()
    
}

class MapPresenter: MapPresenterInput{
    
    var shopDataArray: [ShopDataDic]?
    
    private var view: MapPresenterOutput!
    private var gourmandAPIModel: GourmandAPIInput!
    private var travelAPIModel: TravelAPIInput!
    
    init(view: MapViewController) {
        self.view = view
        let gourmandAPIModel = GourmandAPIModel(presenter: self)
        self.gourmandAPIModel = gourmandAPIModel
        self.travelAPIModel = TravelAPIModel()
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
        self.view.setUpMap(idoValue:idoValue,keidoValue:keidoValue)
    }
    
}

extension MapPresenter: TravelAPIOutput{
    
    
    
}
