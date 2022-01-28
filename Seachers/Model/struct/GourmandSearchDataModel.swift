//
//  GourmandSearchDataModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/12.
//

import Foundation
import UIKit
import CoreLocation

struct GourmandSearchDataModel{
    var place:PlaceSearchDataModel
    var genre:[GenreViewModel]
    var date:DateModel
    var memberCount:Int
    
    init(){
        self.place = PlaceSearchDataModel(transitionSourceName: nil)
        self.genre = [GenreViewModel]()
        self.date = DateModel()
        memberCount = 2
    }
}

struct GenreViewModel{
    var name:String
    var id:String
    var selected:Bool
    var selectbuttonImageID:String{
        switch self.selected{
        case false: return "checkmark.circle"
        case true: return "checkmark.circle.fill"
        }
    }
    var selectButtonImageColor:UIColor{
        switch self.selected{
        case false: return .lightGray
        case true: return .red
        }
    }
    init(){
        self.name = String()
        self.id = String()
        self.selected = false
    }
}



