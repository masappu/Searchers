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
        formatter.dateFormat = "MM月dd日(EEE) HH時mm分"
        formatter.locale = Locale(identifier: "ja_JP") 
        return formatter
    }
    
    private func initialDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日(EEE)"
        formatter.locale = Locale(identifier: "ja_JP")
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

struct CheckInDate{
    private (set) var dateString:String
    
    var date:Date{
        didSet{
            self.dateString = dateFormatter.string(from: date)
        }
    }
    
    private var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd(EEE)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
    
    private func initialDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd(EEE)"
        formatter.locale = Locale(identifier: "ja_JP")
        let initialDateString = formatter.string(from: Date())

        return self.dateFormatter.date(from: initialDateString)!
    }
    

    init(){
        self.dateString = String()
        self.date = Date()
        self.date = initialDate()
        self.dateString = self.dateFormatter.string(from: self.date)
    }
}

struct CheckOutDate{
    
    private (set) var dateString:String
    
    var date:Date{
        didSet{
            self.dateString = dateFormatter.string(from: date)
        }
    }
    
    var changeDate:Date{
        didSet{
            let day = Calendar.current.date(byAdding: .day, value: 1, to: changeDate)
            self.dateString = dateFormatter.string(from: day!)
            self.changeDate = day!
        }
    }
    
    private var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd(EEE)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
        
    private func initialDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd(EEE)"
        formatter.locale = Locale(identifier: "ja_JP")
        let day = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let initialNextDateString = formatter.string(from: day!)
        
        return self.dateFormatter.date(from: initialNextDateString)!
    }
    
    init(){
        self.dateString = String()
        self.date = Date()
        self.changeDate = Date()
        self.date = initialDate()
        self.dateString = self.dateFormatter.string(from: self.date)
    }
}

