//
//  PlaceSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/11.
//

import Foundation

protocol PlaceSearchPresenterInput{
    
    var placeData:PlaceSearchDataModel {get set}
    func loadView(Data:PlaceSearchDataModel)
    func searchButton()
    func searchData(name:String,longitude:Double,latitude:Double)
    func didSelectCell(index:Int)
    func didSelectPickerData(Data:String)
}

protocol PlaceSearchPresenterOutput{
    
    func setTableViewInfo()
    func reloadTableView()
    func startGooglePlaces()
    func AutocompleteControllerDismiss(selectedData: PlaceSearchDataModel)
    func pickerViewIsHidden()
    func reloadDistanceLabel()
}

final class PlaceSearchPresenter: PlaceSearchPresenterInput{
    
    private var view: PlaceSearchPresenterOutput!
    var placeData: PlaceSearchDataModel = PlaceSearchDataModel()
    
    init(view:PlaceSearchPresenterOutput){
        self.view = view
    }
    
    func loadView(Data:PlaceSearchDataModel) {
        self.placeData = Data
        self.view.setTableViewInfo()
        self.view.reloadTableView()
    }
    
    func searchButton(){
        self.view.startGooglePlaces()
    }
    
    func searchData(name: String, longitude: Double, latitude: Double) {
        self.placeData.name = name
        self.placeData.locaitonAtSearchPlace?.longitude = longitude
        self.placeData.locaitonAtSearchPlace?.latitude = latitude
        self.view.AutocompleteControllerDismiss(selectedData: placeData)
    }
    
    func didSelectCell(index: Int) {
        if index == 2{
            self.view.pickerViewIsHidden()
        }
    }
    
    func didSelectPickerData(Data: String) {
        self.placeData.searchRange = Int(Data)!
        self.view.reloadDistanceLabel()
    }
    
}
