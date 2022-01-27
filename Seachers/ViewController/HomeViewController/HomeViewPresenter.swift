//
//  HomeViewPresenter.swift
//  Seachers
//
//  Created by 西林遼太郎 on 2022/01/27.
//

import Foundation

protocol HomeViewPresenterInput{
    var tableViewData:[TableViewData] {get set}
    func viewDidLoad()
    func didSelectCell(indexPath:IndexPath)
}

protocol HomeViewPresenterOutput{
    func setTableViewInfo()
    func reloadTableView()
    func trasitonToNetShoppingVC()
    func transitionToGourmandSearchVC()
    func transitionToTravelSearchVC()
}

struct TableViewData{
    let goToSearchButtonName:String
    var iconStringID:String{
        if goToSearchButtonName == "ネット検索"{
            return "cart"
        }else if goToSearchButtonName == "グルメ検索"{
            return "fork.knife"
        }else{
            return "airplane"
        }
    }
    var row:Int{
        if goToSearchButtonName == "ネット検索"{
            return 0
        }else if goToSearchButtonName == "グルメ検索"{
            return 1
        }else{
            return 2
        }
    }

}

class HomeViewPresenter:HomeViewPresenterInput{
    
    var tableViewData: [TableViewData] = [TableViewData(goToSearchButtonName: "ネット検索"),TableViewData(goToSearchButtonName: "グルメ検索"),TableViewData(goToSearchButtonName: "旅行・宿検索")]
    private var view:HomeViewPresenterOutput
    
    init(view:HomeViewPresenterOutput){
        self.view = view
    }
    
    func viewDidLoad() {
        view.setTableViewInfo()
        view.reloadTableView()
    }
    
    func didSelectCell(indexPath: IndexPath) {
        if indexPath.row == 0{
            view.trasitonToNetShoppingVC()
        }else if indexPath.row == 1{
            view.transitionToGourmandSearchVC()
        }else if indexPath.row == 2{
            view.transitionToTravelSearchVC()
        }
    }
}
