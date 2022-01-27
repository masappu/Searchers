//
//  PlaceSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/11.
//

import Foundation
import CoreLocation

protocol PlaceSearchPresenterInput{
    
    var placeData:PlaceSearchDataModel {get set}
    func loadView(Data:PlaceSearchDataModel)
    func searchButton()
    func searchData(name:String,place: CLLocationCoordinate2D)
    func didSelectCell(index:Int)
    func didSelectPickerData(selectedData:String)
    func pushDoneButton()
}

protocol PlaceSearchPresenterOutput{
    
    func setTableViewInfo()
    func reloadTableView()
    func startGooglePlaces()
    func AutocompleteControllerDismiss(selectedData: PlaceSearchDataModel)
    func pickerViewIsHidden()
    func reloadDistanceLabel()
    func goBack(selectedData:PlaceSearchDataModel)
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
    
    func searchData(name: String, place: CLLocationCoordinate2D) {
        self.placeData.name = name
        self.placeData.locaitonAtSearchPlace = place
        self.view.AutocompleteControllerDismiss(selectedData: placeData)
    }
    
    func didSelectCell(index: Int) {
        if index == 2{
            self.view.pickerViewIsHidden()
        }
    }
    
    func didSelectPickerData(selectedData: String) {
        self.placeData.searchRange = Int(selectedData)!
        self.view.reloadDistanceLabel()
    }
    
    func pushDoneButton() {
        self.view.goBack(selectedData: self.placeData)
    }
    
}
