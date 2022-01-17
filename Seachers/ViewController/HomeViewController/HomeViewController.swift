//
//  ViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var NetShoppingButtom: UIButton!
    @IBOutlet weak var GourmandButtom: UIButton!
    @IBOutlet weak var TravelButtom: UIButton!
    @IBOutlet weak var FavoriteButtom: UIButton!
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    
    let image = UIImage(named: "")
    let a = [UIImage(named: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BackgroundImage.image = newImage
        let fade = CATransition()
        fade.duration = 1
        fade.timingFunction = CAMediaTimingFunction(name: .default)
        fade.type = CATransitionType.fade
        BackgroundImage.layer.add(fade, forKey: "fade")
        
        NetShoppingButtom.layer.cornerRadius = 20
        
        GourmandButtom.layer.cornerRadius = 20
        
        TravelButtom.layer.cornerRadius = 20
        
        FavoriteButtom.layer.borderWidth = 1
        FavoriteButtom.layer.cornerRadius = 10
        
    }

    
}

