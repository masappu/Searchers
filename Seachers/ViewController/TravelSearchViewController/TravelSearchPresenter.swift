//
//  TravelSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/24.
//

import Foundation
import CoreLocation


protocol TravelSearchPresenterInput{
    var searchData:TravelSearchDataModel {get set}
    var rgb:color {get}
    func loadView()
    func didSelectCell(indexPath_row:Int, indexPath_section:Int)
    func datePickerOfCheckInValueChange(date:Date)
    func datePickerOfCheckOutValueChange(date:Date)
    func roomPlusPushButton()
    func roomMinusPushButton()
    func memberPlusPushButton()
    func memberMinusPushButton()
    func receiveData(Data:PlaceSearchDataModel)
    func doneButton()
}

protocol TravelSearchPresenterOutput{
    func setTableViewInfo()
    func setNavigationControllerInfo()
    func transitionToPlaceSearchView()
    func datePickerOfCheckInIsHidden()
    func datePickerOfCheckOutIsHidden()
    func reloadCheckInDateLabel()
    func reloadCheckOutDateLabel()
    func reloadTableView()
    func goMapView()
    func showAlertLocationIsEmpty()
}

final class TravelSearchPresenter: TravelSearchPresenterInput{
    
    
    
    private var view: TravelSearchPresenterOutput!
    private var model:LocationModelInput!
    var searchData: TravelSearchDataModel = TravelSearchDataModel()
    var rgb: color = ColorType(rawValue: "Travel")!.rgb

    init(view:TravelSearchPresenterOutput){
        self.view = view
        let model = LocationModel(presenter: self)
        self.model = model
        let placeData = PlaceSearchDataModel(transitionSourceName: "TravelSearch")
        self.searchData.placeData = placeData
    }
    
    func loadView() {
        self.model.requestAuthorization()
        self.view.setTableViewInfo()
        self.view.setNavigationControllerInfo()
    }
    
    func didSelectCell(indexPath_row: Int, indexPath_section:Int) {
        if indexPath_section == 0{
            self.view.transitionToPlaceSearchView()
        }else if indexPath_section == 1{
            if indexPath_row == 0{
                self.view.datePickerOfCheckInIsHidden()
            }else{
                self.view.datePickerOfCheckOutIsHidden()
            }
        }
    }
    
    func datePickerOfCheckInValueChange(date: Date) {
        self.searchData.checkInDate.date = date
        self.searchData.checkOutDate.changeDate = date
        self.view.reloadCheckInDateLabel()
    }
    
    func datePickerOfCheckOutValueChange(date: Date) {
        self.searchData.checkOutDate.date = date
        self.view.reloadCheckOutDateLabel()
    }
    
    func roomPlusPushButton() {
        if self.searchData.roomNum < 10{
            self.searchData.roomNum += 1
        }
        self.view.reloadTableView()
    }
    
    func roomMinusPushButton() {
        if self.searchData.roomNum > 1{
            self.searchData.roomNum -= 1
        }
        self.view.reloadTableView()
    }
    
    func memberPlusPushButton() {
        if self.searchData.adultNum < 99{
            self.searchData.adultNum += 1
        }
        self.view.reloadTableView()
    }
    
    func memberMinusPushButton() {
        if self.searchData.adultNum > 1{
            self.searchData.adultNum -= 1
        }
        self.view.reloadTableView()
    }
    
    func receiveData(Data:PlaceSearchDataModel) {
        self.searchData.placeData = Data
        self.view.reloadTableView()
    }
    
    func doneButton() {
        if self.searchData.placeData?.locaitonAtSearchPlace == nil{
            self.view.showAlertLocationIsEmpty()
        }
        self.view.goMapView()
    }
    
    
}

// MARK: - LocationModelOutput
extension TravelSearchPresenter:LocationModelOutput{
    
    
    func completedRequestLocaiton(request: CLLocationCoordinate2D) {
        self.searchData.placeData?.locaitonAtCurrent = request
    }
    
    
}

