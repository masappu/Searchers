//
//  GourmandDataLoadModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/13.
//

import Foundation

protocol GourmandGenreModelInput{
    
    //データを受け渡す変数
    var genreData:[GenreModel] {get set}
    
    //データ取得のタイミングを依頼する
    func getGourmandGenreData(url:String, key:String, selected:[GenreModel])
    
}

protocol GourmandGenreModelOutput{
    
    //依頼先に取得データを受け渡す
    func completedGourmandGenreData(data:[GenreModel])
}

final class GourmandDataLoadModel:NSObject, GourmandGenreModelInput{
    
    
    private var parser:XMLParser!
    private var presenter:GourmandGenreModelOutput
    
    var genreData: [GenreModel] = []
    
    init(presenter:GourmandGenreModelOutput){
        self.presenter = presenter
    }
    
    
    func getGourmandGenreData(url: String, key: String ,selected: [GenreModel]) {
        let urlString = url + key
        if let url = URL(string: urlString){
            if let parser = XMLParser(contentsOf: url){
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
        }
    }
}

extension GourmandDataLoadModel:XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        <#code#>
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        <#code#>
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        <#code#>
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        <#code#>
    }
}
