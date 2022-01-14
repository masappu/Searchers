//
//  GourmandGenrePresenter.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/13.
//

import Foundation

protocol GourmandGenrePresenterInput{
    
    //View構築のためのGenreデータを保持する変数
    var allGenreData:[GenreModel] {get set}
    
    //Viewの選択中のGenreデータを保持する変数
    var selectedGenreData:[GenreModel] {get set}
    
    //View構築のタイミングを通知する
    func loadView()
    
}

protocol GourmandGenrePresenterOutput{
    
    //tableViewの設定の構築を指示する
    func setTableViewInfo()
    
    //tableViewの構築を指示する
    func reloadTableView()
    
}

final class GourmandGenrePresenter:GourmandGenrePresenterInput{
    
    private var view:GourmandGenrePresenterOutput
    private var model:GourmandGenreModelInput!
    private let url = "https://webservice.recruit.co.jp/hotpepper/genre/v1/?key="
    private let key = "28d7568c4dcea09f"
    internal var selectedGenreData: [GenreModel] = []

    var allGenreData: [GenreModel] = []
    
    init(view:GourmandGenrePresenterOutput){
        self.view = view
        let model = GourmandDataLoadModel(presenter: self)
        self.model = model
    }
    
    func loadView() {
        self.view.setTableViewInfo()
        self.model.getGourmandGenreData(url: self.url, key: self.key)
    }
    
}

extension GourmandGenrePresenter:GourmandGenreModelOutput{
    
    func completedGourmandGenreData(data: [GenreModel]) {
        let getData = data
        for item in getData{
            var newItem = GenreModel()
            newItem.id = item.id
            newItem.name = item.name
            if self.selectedGenreData.first(where: { $0.name.contains(item.name)}) == nil{
                newItem.selected = false
            }else{
                newItem.selected = true
            }
            self.allGenreData.append(newItem)
        }
        self.view.reloadTableView()
    }
}
