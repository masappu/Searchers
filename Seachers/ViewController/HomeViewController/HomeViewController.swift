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
    private var presenter:HomeViewPresenterInput!

    private let itemColor: [UIColor] = [.blue,.orange,.green]
    
    func inject(presenter:HomeViewPresenterInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = HomeViewPresenter(view: self)
        
        
        presenter.viewDidLoad()
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
}
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let iconImage = cell.contentView.viewWithTag(2) as! UIImageView
        let cirleColorImage = cell.contentView.viewWithTag(1) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(3) as! UILabel
        let underLineView = cell.contentView.viewWithTag(4)!
        titleLabel.text = presenter.tableViewData[indexPath.row].goToSearchButtonName
        iconImage.image = UIImage(systemName: self.presenter.tableViewData[indexPath.row].iconStringID)
        iconImage.tintColor = .white
        cirleColorImage.backgroundColor = self.itemColor[indexPath.row]
        cirleColorImage.layer.cornerRadius = 50
        
        underLineView.backgroundColor? = self.itemColor[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

        
}
    

extension HomeViewController:HomeViewPresenterOutput{
    func setTableViewInfo() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    func trasitonToNetShoppingVC() {
        let storyBoard = UIStoryboard(name: "NetShopping", bundle: nil)
        let NetShoppingVC = storyBoard.instantiateViewController(withIdentifier: "NetShopVC")
        navigationController?.pushViewController(NetShoppingVC, animated: true)
    }
    func transitionToGourmandSearchVC() {
        let storyBoard = UIStoryboard(name: "GourmandSearch", bundle: nil)
        let GourmandSearchVC = storyBoard
            .instantiateViewController(withIdentifier: "gourmandSearchVC")
        navigationController?.pushViewController(GourmandSearchVC, animated: true)
    }
    func transitionToTravelSearchVC() {
        let storyBoard = UIStoryboard(name: "TravelSearch", bundle: nil)
        let TravelSearchVC = storyBoard.instantiateViewController(withIdentifier: "travelSearchVC")
        navigationController?.pushViewController(TravelSearchVC, animated: true)
    }
    
}



