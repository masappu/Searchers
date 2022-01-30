//
//  ButtonAnimatedModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/25.
//

import Foundation
import UIKit

enum AnimatType{
    case countCellButton
    case DoneSearchButton
}


class ButtonAnimatedModel{
    
    let withDuration:TimeInterval
    let delay:TimeInterval
    let options:UIView.AnimationOptions
    let transform:CGAffineTransform
    let alpha:CGFloat
    
    
    init(animatType:AnimatType) {
        switch animatType {
        case .countCellButton:
            self.withDuration = 0.05
            self.delay = 0.0
            self.options = UIView.AnimationOptions.curveEaseIn
            self.transform =  CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.alpha = 1
        case .DoneSearchButton:
            self.withDuration = 0.1
            self.delay = 0.0
            self.options = UIView.AnimationOptions.curveEaseIn
            self.transform =  CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.alpha = 0.7
        }
    }
    
    func touchUpInside(sender:UIButton){
//        UIView.animate(withDuration: withDuration, delay: delay, options: options) {
//            sender.transform = self.transform
//            sender.alpha = self.alpha
//        } completion: { _ in
//            UIView.animate(withDuration: self.withDuration, delay: self.delay, options: self.options, animations: {
//                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                sender.alpha = 1
//            }, completion: nil)
//        }
        UIView.animate(withDuration: withDuration, delay: delay, options: options, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            sender.alpha = 1
        }, completion: nil)
    }
    
    func touchDown(sender:UIButton){
        UIView.animate(withDuration: withDuration, delay: delay, options: options, animations: {
            sender.transform = self.transform
            sender.alpha = self.alpha
        }, completion: nil)
    }
    
    func touchUpOutside(sender:UIButton){
        UIView.animate(withDuration: withDuration, delay: delay, options: options, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            sender.alpha = 1
        }, completion: nil)
    }
    
}
