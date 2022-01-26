//
//  ViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    @IBOutlet weak var NetShoppingButtom: UIButton!
    @IBOutlet weak var GourmandButtom: UIButton!
    @IBOutlet weak var TravelButtom: UIButton!
    @IBOutlet weak var FavoriteButtom: UIButton!
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var shoppingImage: UIImageView!
    @IBOutlet weak var gourmandImage: UIImageView!
    @IBOutlet weak var travelImage: UIImageView!
    
    
  
    
//    var player = AVPlayer()
//        let path = Bundle.main.path(forResource: "Sample", ofType: "mov")
//
//    let image = UIImage(named: "")
//    let a = [UIImage(named: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetShoppingButtom.layer.cornerRadius = 20
        GourmandButtom.layer.cornerRadius = 20
        TravelButtom.layer.cornerRadius = 20
        FavoriteButtom.layer.cornerRadius = 10
        
        //背景動画のやつ
        
//        player = AVPlayer(url: URL(fileURLWithPath: path!))
//                player.play()
//
//                let playerLayer = AVPlayerLayer(player: player)
//        //        フレームの大きさを決める
//                playerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
//                playerLayer.videoGravity = .resizeAspectFill
//
//                playerLayer.repeatCount = 0
//                playerLayer.zPosition = -1
//                view.layer.insertSublayer(playerLayer, at: 0)
//
//        //        リピートさせる
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [self] (notification) in
//                    self.player.seek(to: .zero)
//                    self.player.play()

                    //ボタンアニメーション
                    NSLayoutConstraint.activate([
                        NetShoppingButtom.widthAnchor.constraint(equalToConstant: 300),
                        NetShoppingButtom.heightAnchor.constraint(equalToConstant: 40),
                        GourmandButtom.widthAnchor.constraint(equalToConstant: 300),
                        GourmandButtom.heightAnchor.constraint(equalToConstant: 40),
                        TravelButtom.widthAnchor.constraint(equalToConstant: 300),
                        TravelButtom.heightAnchor.constraint(equalToConstant: 40)
                        ])
        
//        shoppingImage.layer.shadowColor = UIColor.black.cgColor
//        shoppingImage.layer.shadowOpacity = 0.8 //濃さ
//        shoppingImage.layer.shadowRadius = 1.5 //ぼかし量
//        shoppingImage.layer.shadowOffset = CGSize(width: 4.0, height: 4.0) //方向
        shoppingImage.layer.cornerRadius = shoppingImage.frame.size.width * 0.5
        shoppingImage.clipsToBounds = true
        
//        gourmandImage.layer.shadowColor = UIColor.black.cgColor
//        gourmandImage.layer.shadowOpacity = 0.8
//        gourmandImage.layer.shadowRadius = 1.5
//        gourmandImage.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        gourmandImage.layer.cornerRadius = gourmandImage.frame.size.width * 0.5
        gourmandImage.clipsToBounds = true
      
        travelImage.layer.cornerRadius = travelImage.frame.size.width * 0.5
        travelImage.clipsToBounds = true
        
//        NetShoppingButtom.layer.shadowColor = UIColor.black.cgColor
//        NetShoppingButtom.layer.shadowOpacity = 0.4
//        NetShoppingButtom.layer.shadowRadius = 1.5
//        NetShoppingButtom.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
//        GourmandButtom.layer.shadowColor = UIColor.black.cgColor
//        GourmandButtom.layer.shadowOpacity = 0.4
//        GourmandButtom.layer.shadowRadius = 1.5
//        GourmandButtom.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
//        TravelButtom.layer.shadowColor = UIColor.black.cgColor
//        TravelButtom.layer.shadowOpacity = 0.4
//        TravelButtom.layer.shadowRadius = 1.5
//        TravelButtom.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
//        FavoriteButtom.layer.shadowColor = UIColor.black.cgColor
//        FavoriteButtom.layer.shadowOpacity = 0.4
//        FavoriteButtom.layer.shadowRadius = 1.5
//        FavoriteButtom.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        
        
                        prepareForAnimation()
                        startAnimate()
        
    }
    
                        func startAnimate() {
                            UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseIn, animations: { [self] in
                                    
                                    
                                }, completion: nil)
                                
                                UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseOut, animations: {
                                    
                                    self.NetShoppingButtom.layer.opacity = 1
                                    self.NetShoppingButtom.layer.setAffineTransform(CGAffineTransform.identity)
                                    self.GourmandButtom.layer.opacity = 1
                                    self.GourmandButtom.layer.setAffineTransform(CGAffineTransform.identity)
                                    self.TravelButtom.layer.opacity = 1
                                    self.TravelButtom.layer.setAffineTransform(CGAffineTransform.identity)
                                    self.shoppingImage.layer.opacity = 1
                                    self.gourmandImage.layer.opacity = 1
                                    self.travelImage.layer.opacity = 1
                         
                                }, completion: nil)
                            }
    
    func prepareForAnimation() {
       
        NetShoppingButtom.layer.opacity = 0
        GourmandButtom.layer.opacity = 0
        TravelButtom.layer.opacity = 0
        shoppingImage.layer.opacity = 0
        gourmandImage.layer.opacity = 0
        travelImage.layer.opacity = 0
        
            
        NetShoppingButtom.layer.setAffineTransform(CGAffineTransform.init(translationX: 0, y: 30))
        GourmandButtom.layer.setAffineTransform(CGAffineTransform .init(translationX: 0, y: 60))
        TravelButtom.layer.setAffineTransform(CGAffineTransform .init(translationX: 0, y: 60))
        
        shoppingImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
        gourmandImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
        travelImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
        }
    
}
    
    

    




