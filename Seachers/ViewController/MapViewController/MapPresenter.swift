//
//  MapPresenter.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/10.
//

import Foundation


protocol MapPresenterInput {
    
    func reloadData()
    //    var data: VideoModel? {get set}
}

protocol MapPresenterOutput {
    
    func reloadMap()
    
}

class MapPresenter: MapPresenterInput{
    
//    var data: VideoModel?
    
    private var view: MapPresenterOutput!
    private var model: MapPresenterInput!
    
    init(view: MapViewController) {
        self.view = view
//        self.model = model
    }
    
    func reloadData() {
        self.view.reloadMap()
    }
    
    
}
