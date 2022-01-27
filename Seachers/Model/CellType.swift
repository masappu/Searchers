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
        case .mamberCountCell: return "memberCountCell"
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

enum TravelSearchCellType: Int, CaseIterable, CellType{
    case selectDestinationCell
    case checkCell
    case roomAndMemberCell
    
    var cellIdentifier: String{
        switch self {
        case .selectDestinationCell: return "selectDestinationCell"
        case .checkCell: return "checkCell"
        case .roomAndMemberCell: return "roomAndmemberCell"
        }
    }
}

enum CheckCellType: Int, CaseIterable, CellType{
    case checkInCell
    case checkOutCell
    
    var cellIdentifier: String{
        switch self {
        case .checkInCell: return "checkInCell"
        case .checkOutCell: return "checkOutCell"
        }
    }
}

enum RoomAndMemberCellType: Int, CaseIterable, CellType{
    case roomAndMemberCell
    case numberOfroomsCountCell
    case numberOfmemberCountCell
    
    var cellIdentifier: String{
        switch self {
        case .roomAndMemberCell: return "roomAndMemberCell"
        case .numberOfroomsCountCell: return "roomCountOfTravelCell"
        case .numberOfmemberCountCell: return "memberCountOfTravelCell"
        }
    }
}
