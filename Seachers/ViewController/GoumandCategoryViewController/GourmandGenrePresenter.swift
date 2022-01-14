//
//  GourmandGenrePresenter.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/13.
//

import Foundation

protocol GourmandGenrePresenterInput{
    
    //View構築のためのGenreデータを保持する変数
    var genreData:[GenreModel] {get}
    
    //View構築のタイミングを通知する
    func loadView(data:[GenreModel])
    
}

protocol GourmandGenrePresenterOutput{
    
    //tableViewの設定の構築を指示する
    func setTableViewInfo()
    
    //tableViewの構築を指示する
    func reloadTableView()
    
}

final class GourmandGenrePresenter:GourmandGenrePresenterInput{
    
    private var view:GourmandGenrePresenterOutput
    private var model:GourmandGenreModelInput
    private let url = "http://webservice.recruit.co.jp/hotpepper/genre/v1/?key="
    private let key = "[28d7568c4dcea09f]"
    var genreData: [GenreModel] = []
    
    init(view:GourmandGenrePresenterOutput){
        self.view = view
        let model = GourmandDataLoadModel(presenter: self)
        self.model = model
    }
    
    func loadView(data:[GenreModel]) {
        self.genreData = data

        self.view.setTableViewInfo()
        self.model.getGourmandGenreData(url: self.url, key: self.key, selected: self.genreData)
    }
    
}

extension GourmandGenrePresenter:GourmandGenreModelOutput{
    
    func completedGourmandGenreData(data: [GenreModel]) {
        <#code#>
    }
}
