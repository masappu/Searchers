//
//  CellType.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/15.
//

import Foundation

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

enum MapCellType: String, CaseIterable, CellType{
    case gourmandCell = "GourmandSearchViewController"
    case travelCell = "TravelSearchViewController"

    var cellIdentifier: String{
        switch self {
        case .gourmandCell: return "GourmandCell"
        case .travelCell: return "TravelCell"
        }
    }
}
