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
    func loadView(Data:GourmandSearchDataModel)
    
    //「検索する」ボタンタップを通知する
    func pushSearchButton()
    
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
    
    //tableViewの構築を指示する
    func reloadTableView()
    
    //memberCountLabelの表示切り替えの指示
    func reloadMemberCountLabel()
    
    //resevationDateLabelの表示更新の指示
    func reloadResevationDateLabel()
    
    //DatePickerの折りたたみ表示変更の指示
    func reloadDatePickerIsHidden()
    
    //MapViewへの遷移を指示する
    func transitionToMapView(Data:GourmandSearchDataModel)
    
    //PlaceSearchViewへの遷移を指示する
    func transitionToPlaceSearchVIew()
    
    //GourmandGenreViewへの遷移を指示する
    func transitionToGourmandGenreView(selectedGenres:[GenreModel])
}

final class GourmandSearchPresenter: GourmandSearchInput{
    
    private var view:GourmandSearchOutput
    private var model:LocationModel!
    var searchData: GourmandSearchDataModel = GourmandSearchDataModel()
    
    init(view:GourmandSearchOutput){
        self.view = view
        let model = LocationModel(presenter: self)
        self.model = model
    }
    
    func loadView(Data: GourmandSearchDataModel) {
        self.searchData = Data
        self.model.requestAuthorization()
        self.view.setTableViewInfo()
    }
    
    func pushSearchButton() {
        self.view.transitionToMapView(Data: self.searchData)
    }
    
    func pushPlusButton() {
        self.searchData.memberCount += 1
        self.view.reloadTableView()
    }
    
    func pushMinusButton() {
        if self.searchData.memberCount > 0{
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

extension GourmandSearchPresenter:LocaitonModelOutput{
    
    func completedRequestLocaiton(request: CLLocationCoordinate2D) {
        self.searchData.place.locaitonAtCurrent = request
        self.view.reloadTableView()
    }
    
}
