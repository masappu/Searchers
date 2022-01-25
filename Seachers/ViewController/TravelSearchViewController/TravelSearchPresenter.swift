//
//  TravelSearchPresenter.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/24.
//

import Foundation


protocol TravelSearchPresenterInput{
    func loadView()
}

protocol TravelSearchPresenterOutput{
    func setTableViewInfo()
}

final class TravelSearchPresenter: TravelSearchPresenterInput{
    
    private var view: TravelSearchPresenterOutput!
    
    init(view:TravelSearchPresenterOutput){
        self.view = view
    }
    
    func loadView() {
        self.view.setTableViewInfo()
    }
}
