//
//  ImageColorModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/02/04.
//

import Foundation

enum ColorType:String{
    case NetShopping = "NetShopping"
    case Gourmand = "Gourmand"
    case Travel = "Travel"
    case Fav = "Fav"
    
    var rgb:color{
        switch self{
        case.NetShopping:
            return color(r: 0.6, g: 0.6, b: 1.0, alpha: 1.0)
        case.Gourmand:
            return color(r: 1.2, g: 0.6, b: 0.0, alpha: 1.0)
        case.Travel:
            return color(r: 0.0, g: 1.0, b: 0.6, alpha: 1.0)
        case.Fav:
            return color(r: 252 / 255, g: 220 / 255, b: 100 / 255, alpha: 1.0)
        }
    }
}

struct color{
    let r:Double
    let g:Double
    let b:Double
    let alpha:Double
}
