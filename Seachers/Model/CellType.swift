//
//  CellType.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/15.
//

import Foundation
import SwiftUI

protocol CellType{
    //cellを一元管理する変数
    var cellIdentifier: String {get}
    
}

enum GourmandSearchCellType: Int, CaseIterable, CellType{
    case selectDestinationCell
    case selectGenreCell
    case reservationDateCell
    case mamberCountCell

    var cellIdentifier: String{
        switch self {
        case .selectDestinationCell: return "selectDestinationCell"
        case .selectGenreCell: return "selectGenreCell"
        case .reservationDateCell: return "reservationDateCell"
        case .mamberCountCell: return "mamberCountCell"
        }
    }
}

enum SelectGenreCellType:String ,CaseIterable,CellType{
    case selectGenreCell = "exitingData"
    case nonSelectGenreCell = "noData"
    
    var cellIdentifier: String{
        switch self {
        case .selectGenreCell: return "selectGenreCell"
        case .nonSelectGenreCell:return "nonSelectGenreCell"
        }
    }
}

enum MapCellType: Int, CaseIterable, CellType{
    case gourmandCell
    case travelCell

    var cellIdentifier: String{
        switch self {
        case .gourmandCell: return "GourmandCell"
        case .travelCell: return "TravelCell"
        }
    }
}
