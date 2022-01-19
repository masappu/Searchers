//
//  PlaceSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/11.
//

import Foundation

protocol PlaceSearchPresenterInput{
    func loadView()
}

protocol PlaceSearchPresenterOutput{
    func setTableViewInfo()
}

class PlaceSearchPresenter: PlaceSearchPresenterInput{
    
    private var view: PlaceSearchPresenterOutput!
    
    init(view:PlaceSearchPresenterOutput){
        self.view = view
    }
    
    func loadView() {
        
    }
}
