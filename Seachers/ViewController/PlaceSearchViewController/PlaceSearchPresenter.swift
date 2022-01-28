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
    var pickerList:[String] {get set}
    func loadView(Data:PlaceSearchDataModel, transitionSourceName:String)
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
    var placeData: PlaceSearchDataModel
    var pickerList = [String]()
    var unit = String()
    
    
    init(view:PlaceSearchPresenterOutput, initialValue:String){
        self.view = view
        self.placeData = PlaceSearchDataModel(transitionSourceName: initialValue)
    }
    
    func loadView(Data:PlaceSearchDataModel, transitionSourceName:String) {
        self.placeData = Data
        if transitionSourceName == "TravelSearch"{
            self.pickerList = ["1","2","3"]
        }else if transitionSourceName == "Gourmand"{
            self.pickerList = ["300","500","1000","2000","3000"]
        }
        self.view.setTableViewInfo()
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
        self.placeData.searchRange!.searchRange = selectedData
        self.view.reloadDistanceLabel()
        
    }
    
    func pushDoneButton() {
        self.view.goBack(selectedData: self.placeData)
    }
    
}
