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
    var buttonAnimation:ButtonAnimatedModel{get}
    var pickerList:[String] {get}
    var rgb:color {get}
    func loadView(transitionSourceName:String)
    func searchButton()
    func searchData(name:String,place: CLLocationCoordinate2D)
    func didSelectCell(index:Int)
    func didSelectPickerData(selectedData:String)
    func pushDoneButton()
}

protocol PlaceSearchPresenterOutput{
    
    func setTableViewInfo()
    func setNavigationControllerInfo()
    func setButton()
    func reloadTableView()
    func startGooglePlaces()
    func AutocompleteControllerDismiss(selectedData: PlaceSearchDataModel)
    func pickerViewIsHidden()
    func reloadDistanceLabel()
    func goBack(selectedData:PlaceSearchDataModel)
}

final class PlaceSearchPresenter: PlaceSearchPresenterInput{
    
    
    private var view: PlaceSearchPresenterOutput!
    private var transitionSourceName: String?
    var placeData: PlaceSearchDataModel
    var buttonAnimation = ButtonAnimatedModel(animatType: .DoneButton)
    var pickerList: [String]{
        if self.transitionSourceName == "TravelSearch"{
            return ["1","2","3"]
        }else{
            return ["300","500","1000","2000","3000"]
        }
    }
    var unit = String()
    var rgb: color{
        if self.transitionSourceName == "TravelSearch"{
            return ColorType(rawValue: "Travel")!.rgb
        }else{
            return ColorType(rawValue: "Gourmand")!.rgb
        }
    }
    
    
    init(view:PlaceSearchPresenterOutput, initialValue:String){
        self.view = view
        self.placeData = PlaceSearchDataModel(transitionSourceName: initialValue)
    }
    
    func loadView(transitionSourceName:String) {
        self.transitionSourceName = transitionSourceName
        self.view.setButton()
        self.view.setTableViewInfo()
        self.view.setNavigationControllerInfo()
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
        if index == 1{
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
