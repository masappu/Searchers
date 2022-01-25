//
//  TravelSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/24.
//

import Foundation


protocol TravelSearchPresenterInput{
    func loadView()
    func didSelectCell(indexPath_row:Int, indexPath_section:Int)
}

protocol TravelSearchPresenterOutput{
    func setTableViewInfo()
    func transitionToPlaceSearchView()
    func datePickerOfCheckInIsHidden()
    func datePickerOfCheckOutIsHidden()
}

final class TravelSearchPresenter: TravelSearchPresenterInput{
    
    private var view: TravelSearchPresenterOutput!
    
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
}
