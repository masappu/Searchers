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
    @IBOutlet weak var ShoppingImage: UIImageView!
    @IBOutlet weak var GourmandImage: UIImageView!
    @IBOutlet weak var TravelImage: UIImageView!
    
    
  
    
    var player = AVPlayer()
        let path = Bundle.main.path(forResource: "Sample", ofType: "mov")
    
    let image = UIImage(named: "")
    let a = [UIImage(named: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fade = CATransition()
        fade.duration = 3
        fade.timingFunction = CAMediaTimingFunction(name: .default)
        fade.type = CATransitionType.fade
        BackgroundImage.layer.add(fade, forKey: "fade")
        
        NetShoppingButtom.layer.cornerRadius = 20
        
        GourmandButtom.layer.cornerRadius = 20
        
        TravelButtom.layer.cornerRadius = 20
        
        FavoriteButtom.layer.borderWidth = 1
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
        
        ShoppingImage.layer.shadowColor = UIColor.black.cgColor
        ShoppingImage.layer.shadowOpacity = 0.8 //濃さ
        ShoppingImage.layer.shadowRadius = 5.0 //ぼかし量
        ShoppingImage.layer.shadowOffset = CGSize(width: 8.0, height: 8.0) //方向
        GourmandImage.layer.shadowColor = UIColor.black.cgColor
        GourmandImage.layer.shadowOpacity = 0.8
        GourmandImage.layer.shadowRadius = 5.0
        GourmandImage.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        TravelImage.layer.shadowColor = UIColor.black.cgColor
        TravelImage.layer.shadowOpacity = 0.8
        TravelImage.layer.shadowRadius = 5.0
        TravelImage.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        NetShoppingButtom.layer.shadowColor = UIColor.black.cgColor
        NetShoppingButtom.layer.shadowOpacity = 0.8
        NetShoppingButtom.layer.shadowRadius = 5.0
        NetShoppingButtom.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        GourmandButtom.layer.shadowColor = UIColor.black.cgColor
        GourmandButtom.layer.shadowOpacity = 0.8
        GourmandButtom.layer.shadowRadius = 5.0
        GourmandButtom.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        TravelButtom.layer.shadowColor = UIColor.black.cgColor
        TravelButtom.layer.shadowOpacity = 0.8
        TravelButtom.layer.shadowRadius = 5.0
        TravelButtom.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        FavoriteButtom.layer.shadowColor = UIColor.black.cgColor
        FavoriteButtom.layer.shadowOpacity = 0.8
        FavoriteButtom.layer.shadowRadius = 5.0
        FavoriteButtom.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        
        
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
                                    self.ShoppingImage.layer.opacity = 1
                                    self.GourmandImage.layer.opacity = 1
                                    self.TravelImage.layer.opacity = 1
                         
                                }, completion: nil)
                            }
    
    func prepareForAnimation() {
       
        NetShoppingButtom.layer.opacity = 0
        GourmandButtom.layer.opacity = 0
        TravelButtom.layer.opacity = 0
        ShoppingImage.layer.opacity = 0
        GourmandImage.layer.opacity = 0
        TravelImage.layer.opacity = 0
        
            
        NetShoppingButtom.layer.setAffineTransform(CGAffineTransform.init(translationX: 0, y: 30))
        GourmandButtom.layer.setAffineTransform(CGAffineTransform .init(translationX: 0, y: 60))
        TravelButtom.layer.setAffineTransform(CGAffineTransform .init(translationX: 0, y: 60))
        
        ShoppingImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
        GourmandImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
        TravelImage.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.8))
        }
 
    

    
}



