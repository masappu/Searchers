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
    case reservationDateCell
    case roomTableViewCell
    
    var cellIdentifier: String{
        switch self {
        case .selectDestinationCell: return "selectDestinationCell"
        case .reservationDateCell: return "reservationDateCell"
        case .roomTableViewCell: return "roomTableViewCell"
        }
    }
}

enum ReservationDateCellType: Int, CaseIterable, CellType{
    case checkInCell
    case checkOutCell
    
    var cellIdentifier: String{
        switch self {
        case .checkInCell: return "reservationDateCell"
        case .checkOutCell: return "reservationDateCell"
        }
    }
}

enum RoomTableViewCellType: Int, CaseIterable, CellType{
    case roomTableViewCell
    case numberOfroomsCountCell
    case numberOfmamberCountCell
    
    var cellIdentifier: String{
        switch self {
        case .roomTableViewCell: return "roomTableViewCell"
        case .numberOfroomsCountCell: return "memberCountCell"
        case .numberOfmamberCountCell: return "memberCountCell"
        }
    }
}
