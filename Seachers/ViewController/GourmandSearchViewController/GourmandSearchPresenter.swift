//
//  GourmandSearchPresenter.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/11.
//

import Foundation
import CoreLocation


protocol GourmandSearchInput{
    
    //検索条件を受け渡す変数
    var searchData:GourmandSearchDataModel {get set}
    
    //viewの構築のタイミングを通知する
    func loadView()
    
    //selectGenreCellの構築のタイミングを通知する
    func loadSelectGenreCell() -> String
    
    //「検索する」ボタンタップを通知する
    func pushSearchButton()
    
    //Genreのデリートボタンのタップを通知する
    func deleteGenreData(indexPath row: Int)
    
    //プラスボタンのタップを通知する
    func pushPlusButton()
    
    //マイナスボタンのタップを通知する
    func pushMinusButton()
    
    //DatePickerの値変更を通知する
    func datePickerValueChange(date: Date)
    
    //セルのタップを通知する
    func didSelsctCell(index: Int)
    
}

protocol GourmandSearchOutput{
    
    //tableViewの設定構築を指示
    func setTableViewInfo()
    
    func setNavigationControllerInfo()
    
    //tableViewの構築を指示する
    func reloadTableView()
    
    //selectGenreCellの表示変更を指示
    func reloadSelectGenreCell(at indexPaths:[IndexPath])
    
    //tableViewのreloadRows()の実行を指示
    func reloadTableViewCell(at IndexPaths:[IndexPath])
    
    //memberCountLabelの表示切り替えの指示
    func reloadMemberCountLabel()
    
    //resevationDateLabelの表示更新の指示
    func reloadResevationDateLabel()
    
    //DatePickerの折りたたみ表示変更の指示
    func reloadDatePickerIsHidden()
    
    //MapViewへの遷移を指示する
    func transitionToMapView(Data:GourmandSearchDataModel, previousVCString:String)
    
    //PlaceSearchViewへの遷移を指示する
    func transitionToPlaceSearchVIew()
    
    //GourmandGenreViewへの遷移を指示する
    func transitionToGourmandGenreView(selectedGenres:[GenreViewModel])
}

final class GourmandSearchPresenter: GourmandSearchInput{
    
    private var view:GourmandSearchOutput
    private var model:LocationModelInput!
    private let previousVCString = "GourmandSearchViewController"
    var searchData: GourmandSearchDataModel = GourmandSearchDataModel()
    
    
    init(view:GourmandSearchOutput){
        self.view = view
        let model = LocationModel(presenter: self)
        self.model = model
    }
    
    func loadView() {
        self.model.requestAuthorization()
        self.view.setTableViewInfo()
        self.view.reloadTableView()
    }
    
    func loadSelectGenreCell() -> String {
        if self.searchData.genre.count == 0{
            return "noData"
        }else{
            return "exitingData"
        }
    }
    
    func pushSearchButton() {
        self.view.transitionToMapView(Data: self.searchData, previousVCString: self.previousVCString)
    }
    
    func deleteGenreData(indexPath row: Int) {
        guard row >= 0 && row < self.searchData.genre.count else { return }
        self.searchData.genre.remove(at: row)
        
        if self.searchData.genre.count == 0{
            let indexPaths = [IndexPath(row: 0, section: 1)]
            self.view.reloadTableViewCell(at: indexPaths)
        }else{
            let indexPaths = [IndexPath(row: row, section: 0)]
            self.view.reloadSelectGenreCell(at: indexPaths)
        }
    }
    
    func pushPlusButton() {
        self.searchData.memberCount += 1
        self.view.reloadTableView()
    }
    
    func pushMinusButton() {
        if self.searchData.memberCount > 1{
            self.searchData.memberCount -= 1
        }
        self.view.reloadTableView()
    }
    
    func datePickerValueChange(date: Date) {
        self.searchData.date.date = date
        self.view.reloadResevationDateLabel()
    }
    
    func didSelsctCell(index: Int) {
        if index == 0{
            self.view.transitionToPlaceSearchVIew()
        }else if index == 1{
            self.view.transitionToGourmandGenreView(selectedGenres: self.searchData.genre)
        }else if index == 2{
            self.view.reloadDatePickerIsHidden()
        }
    }
    
}

extension GourmandSearchPresenter:LocationModelOutput{
    
    func completedRequestLocaiton(request: CLLocationCoordinate2D) {
        self.searchData.place.locaitonAtCurrent = request
    }
    
}
