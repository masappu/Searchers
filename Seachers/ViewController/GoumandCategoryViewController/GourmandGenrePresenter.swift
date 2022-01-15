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
    var selectedGenres:[GenreModel] {get set}
    
    //View構築のタイミングを通知する
    func loadView(selectedDate:[GenreModel])
    
    //selectedButton（Genreの選択）を通知する
    func pushSelectedButton(indexPath:IndexPath)
    
    //clearButtonのタップを通知する
    func pushClearButton()
    
    //決定ボタンが押されたことを通知する
    func pushDoneButton()
    
}

protocol GourmandGenrePresenterOutput{
    
    //tableViewの設定の構築を指示する
    func setTableViewInfo()
    
    //ナビゲーションコントローラーの設定を指示する
    func setNavigationItemInfo()
    
    //tableViewの構築を指示する
    func reloadTableView()
    
    //selectedButtonの表示更新を指示する
    func reloadSelectedButton(at indexArray:[IndexPath])
    
    //前画面に戻る指示
    func goBack(selectedData:[GenreModel])
    
}

final class GourmandGenrePresenter:GourmandGenrePresenterInput{
    
    private var view:GourmandGenrePresenterOutput
    private var model:GourmandGenreModelInput!
    private let url = "https://webservice.recruit.co.jp/hotpepper/genre/v1/?key="
    private let key = "28d7568c4dcea09f"
    internal var selectedGenres: [GenreModel] = []
    var allGenreData: [GenreModel] = []
    
    init(view:GourmandGenrePresenterOutput){
        self.view = view
        let model = GourmandDataLoadModel(presenter: self)
        self.model = model
    }
    
    func loadView(selectedDate:[GenreModel]) {
        self.selectedGenres = selectedDate
        self.view.setTableViewInfo()
        self.view.setNavigationItemInfo()
        self.model.getGourmandGenreData(url: self.url, key: self.key)
    }
    
    func pushSelectedButton(indexPath: IndexPath) {
        self.allGenreData[indexPath.row].selected.toggle()
        if self.allGenreData[indexPath.row].selected == true{
            self.selectedGenres.append(self.allGenreData[indexPath.row])
            
        }else{
            self.selectedGenres.removeAll(where: {$0.id == self.allGenreData[indexPath.row].id})
        }
        self.view.reloadSelectedButton(at: [indexPath])
    }
    
    func pushClearButton() {
        var indexArray = [IndexPath]()
        for i in 0..<self.allGenreData.count{
            if self.allGenreData[i].selected{
                let indexPath = IndexPath(row: i, section: 0)
                indexArray.append(indexPath)
                self.allGenreData[i].selected.toggle()
            }
        }
        self.view.reloadSelectedButton(at: indexArray)
        self.selectedGenres.removeAll()
    }
    
    func pushDoneButton() {
        self.view.goBack(selectedData: self.selectedGenres)
    }
}

extension GourmandGenrePresenter:GourmandGenreModelOutput{
    
    func completedGourmandGenreData(data: [GenreModel]) {
        let getData = data
        for item in getData{
            var newItem = GenreModel()
            newItem.id = item.id
            newItem.name = item.name
            if self.selectedGenres.first(where: { $0.name.contains(item.name)}) == nil{
                newItem.selected = false
            }else{
                newItem.selected = true
            }
            self.allGenreData.append(newItem)
        }
        self.view.reloadTableView()
    }
}
