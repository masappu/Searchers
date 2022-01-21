//
//  PlaceSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/11.
//

import Foundation

protocol PlaceSearchPresenterInput{
    func loadView()
    func searchButton()
    func searchData(Data:PlaceDataModel)
}

protocol PlaceSearchPresenterOutput{
    func setTableViewInfo()
    func reloadTableView()
    func startGooglePlaces()
    func AutocompleteControllerDismiss(selectedData: PlaceDataModel)
}

final class PlaceSearchPresenter: PlaceSearchPresenterInput{
    
    
    private var view: PlaceSearchPresenterOutput!
    var placeDataModel: PlaceDataModel!
    
    init(view:PlaceSearchPresenterOutput){
        self.view = view
    }
    
    func loadView() {
        self.view.setTableViewInfo()
        self.view.reloadTableView()
    }
    
    func searchButton(){
        self.view.startGooglePlaces()
    }
    
    func searchData(Data:PlaceDataModel) {
        self.view.AutocompleteControllerDismiss(selectedData: Data)
    }
    
}
