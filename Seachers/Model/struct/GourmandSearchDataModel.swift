//
//  GourmandSearchDataModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/12.
//

import Foundation

struct GourmandSearchDataModel{
    var place:PlaceSearchDataModel
    var genre:GenreModel
    var date:DateModel
    var memberCount:Int
    
    init(){
        self.place = PlaceSearchDataModel()
        self.genre = GenreModel()
        self.date = DateModel()
        memberCount = 2
    }
}


struct GenreModel{
    var name:[String]
    var id:[String]
    
    init(){
        self.name = []
        self.id = []
    }
}


