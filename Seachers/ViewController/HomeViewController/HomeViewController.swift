//
//  ViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
  
    
//    var player = AVPlayer()
//        let path = Bundle.main.path(forResource: "Sample", ofType: "mov")
//
//    let image = UIImage(named: "")
//    let a = [UIImage(named: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoriteButton.layer.cornerRadius = 10

//                    //ボタンアニメーション
//                    NSLayoutConstraint.activate([
//                        NetShoppingButtom.widthAnchor.constraint(equalToConstant: 300),
//                        NetShoppingButtom.heightAnchor.constraint(equalToConstant: 40),
//                        GourmandButtom.widthAnchor.constraint(equalToConstant: 300),
//                        GourmandButtom.heightAnchor.constraint(equalToConstant: 40),
//                        TravelButtom.widthAnchor.constraint(equalToConstant: 300),
//                        TravelButtom.heightAnchor.constraint(equalToConstant: 40)
//                        ])
//
//        shoppingImage.layer.cornerRadius = shoppingImage.frame.size.width * 0.5
//        shoppingImage.clipsToBounds = true
//
//        gourmandImage.layer.cornerRadius = gourmandImage.frame.size.width * 0.5
//        gourmandImage.clipsToBounds = true
//
//        travelImage.layer.cornerRadius = travelImage.frame.size.width * 0.5
//        travelImage.clipsToBounds = true
//
//
//
//                        prepareForAnimation()
//                        startAnimate()
//
//    }
//
//                        func startAnimate() {
//                            UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseIn, animations: { [self] in
//
//
//                                }, completion: nil)
//
//                                UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseOut, animations: {
//
//                                    self.NetShoppingButtom.layer.opacity = 1
//                                    self.NetShoppingButtom.layer.setAffineTransform(CGAffineTransform.identity)
//                                    self.GourmandButtom.layer.opacity = 1
//                                    self.GourmandButtom.layer.setAffineTransform(CGAffineTransform.identity)
//                                    self.TravelButtom.layer.opacity = 1
//                                    self.TravelButtom.layer.setAffineTransform(CGAffineTransform.identity)
//                                    self.shoppingImage.layer.opacity = 1
//                                    self.gourmandImage.layer.opacity = 1
//                                    self.travelImage.layer.opacity = 1
//
//                                }, completion: nil)
//                            }
//
//    func prepareForAnimation() {
//
//        NetShoppingButtom.layer.opacity = 0
//        GourmandButtom.layer.opacity = 0
//        TravelButtom.layer.opacity = 0
//        shoppingImage.layer.opacity = 0
//        gourmandImage.layer.opacity = 0
//        travelImage.layer.opacity = 0
//
//
//        NetShoppingButtom.layer.setAffineTransform(CGAffineTransform.init(translationX: 0, y: 30))
//        GourmandButtom.layer.setAffineTransform(CGAffineTransform .init(translationX: 0, y: 60))
//        TravelButtom.layer.setAffineTransform(CGAffineTransform .init(translationX: 0, y: 60))
//
//        shoppingImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
//        gourmandImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
//        travelImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
//        }
//
}
    
    

    




