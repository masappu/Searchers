//
//  TravelSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/24.
//

import Foundation


protocol TravelSearchPresenterInput{
    var searchData:TravelSearchDataModel {get set}
    func loadView()
    func didSelectCell(indexPath_row:Int, indexPath_section:Int)
    func datePickerOfCheckInValueChange(date:Date)
    func datePickerOfCheckOutValueChange(date:Date)
    func roomPlusPushButton()
    func roomMinusPushButton()
    func memberPlusPushButton()
    func memberMinusPushButton()
}

protocol TravelSearchPresenterOutput{
    func setTableViewInfo()
    func transitionToPlaceSearchView()
    func datePickerOfCheckInIsHidden()
    func datePickerOfCheckOutIsHidden()
    func reloadCheckInDateLabel()
    func reloadCheckOutDateLabel()
    func reloadTableView()
}

final class TravelSearchPresenter: TravelSearchPresenterInput{
    
    private var view: TravelSearchPresenterOutput!
    var searchData: TravelSearchDataModel = TravelSearchDataModel()
    
    init(view:TravelSearchPresenterOutput){
        self.view = view
    }
    
    func loadView() {
        self.view.setTableViewInfo()
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
}
