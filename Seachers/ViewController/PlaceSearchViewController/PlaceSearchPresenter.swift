//
//  PlaceSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/11.
//

import Foundation
import CoreLocation
import UIKit

protocol PlaceSearchPresenterInput{
    
    var placeData:PlaceSearchDataModel {get set}
    var pickerList:[String] {get set}
    var color:UIColor {get set}
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
    var placeData: PlaceSearchDataModel
    var pickerList = [String]()
    var unit = String()
    var color = UIColor()
    
    
    init(view:PlaceSearchPresenterOutput, initialValue:String){
        self.view = view
        self.placeData = PlaceSearchDataModel(transitionSourceName: initialValue)
    }
    
    func loadView(transitionSourceName:String) {
        if transitionSourceName == "TravelSearch"{
            self.pickerList = ["1","2","3"]
            self.color = .green
        }else if transitionSourceName == "Gourmand"{
            self.pickerList = ["300","500","1000","2000","3000"]
            self.color = .orange
        }
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
