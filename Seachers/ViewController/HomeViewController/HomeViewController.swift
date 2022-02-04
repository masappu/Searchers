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
    }
    
}
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let iconImage = cell.contentView.viewWithTag(2) as! UIImageView
        let cirleColorView = cell.contentView.viewWithTag(1) as! UIView
        let titleLabel = cell.contentView.viewWithTag(3) as! UILabel
        let underLineView = cell.contentView.viewWithTag(4)!
        titleLabel.text = presenter.tableViewData[indexPath.row].goToSearchButtonName
        iconImage.image = UIImage(systemName: self.presenter.tableViewData[indexPath.row].iconStringID)
        iconImage.tintColor = .white
        cirleColorView.backgroundColor = self.itemColor[indexPath.row]
        cirleColorView.layer.cornerRadius = 50
        
        underLineView.backgroundColor? = self.itemColor[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
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



