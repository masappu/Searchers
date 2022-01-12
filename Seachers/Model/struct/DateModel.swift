//
//  DateModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/12.
//

import Foundation

struct DateModel{
    private (set) var dateString:String
    
    var date:Date{
        didSet{
            self.dateString = dateFormatter.string(from: date)
        }
    }
    
    private var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        
        return formatter
    }
    
    private func initialDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        let initialDateString = formatter.string(from: Date()) + "19:00"

        return formatter.date(from: initialDateString)!
    }

    init(){
        self.dateString = String()
        self.date = Date()
        self.date = initialDate()
    }
}
