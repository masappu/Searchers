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
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy年MM月dd日 HH時mm分", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.dateFormat = "MM月dd日(EEE) HH時mm分"
        formatter.locale = Locale(identifier: "ja_JP") 
        return formatter
    }
    
    private func initialDate() -> Date{
        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy年MM月dd日", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.dateFormat = "MM月dd日(EEE)"
        formatter.locale = Locale(identifier: "ja_JP")
        print(formatter.string(from: Date()))
        let initialDateString = formatter.string(from: Date()) + " 19時00分"

        return self.dateFormatter.date(from: initialDateString)!
    }

    init(){
        self.dateString = String()
        self.date = Date()
        self.date = initialDate()
        self.dateString = self.dateFormatter.string(from: self.date)
    }
}
