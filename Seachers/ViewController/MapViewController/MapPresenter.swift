//
//  MapPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/10.
//

import Foundation


protocol MapPresenterInput {
    
    func reloadData()
    var shopDataArray: [ShopDataDic]? {get set}
}

protocol MapPresenterOutput {
    
    func reloadMap()
    
    func reloadCollectionView()
    
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
    
    func reloadData() {
        self.view.reloadCollectionView()
        gourmandAPIModel.setData()
    }
    
}

extension MapPresenter: GourmandAPIOutput{
    
    func resultAPIData(shopDataArray: [ShopDataDic]) {
        self.shopDataArray = shopDataArray
        self.view.reloadMap()
    }

}

extension MapPresenter: TravelAPIOutput{
    
    
    
}
