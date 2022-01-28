//
//  FavOfTravelViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit
import SDWebImage

class FavOfTravelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var presenter:FavOfTravelPresenterInput!
    
    func inject(presenter:FavOfTravelPresenter){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let presenter = FavOfTravelPresenter(view: self)
        inject(presenter: presenter)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewwillAppear()
    }
    
}

extension FavOfTravelViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favShopDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favTravelCell", for: indexPath)
        let hotelImage = cell.contentView.viewWithTag(1) as! UIImageView
        let areaLabel = cell.contentView.viewWithTag(2) as! UILabel
        let hotelNameLabel = cell.contentView.viewWithTag(3) as! UILabel
        let priceLabel = cell.contentView.viewWithTag(4) as! UILabel
        
        let viewData = presenter.favShopDataArray[indexPath.row]
        
        hotelImage.sd_setImage(with: URL(string: viewData.hotelImageUrl))
        areaLabel.text = viewData.area + "/" + viewData.nearestStation + "駅"
        hotelNameLabel.text = viewData.hotelName
        priceLabel.text = "税込" + String(viewData.hotelMinCharge) + "円〜"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
        
}

extension FavOfTravelViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        let deleteAction = UIContextualAction(style: .destructive, title:"delete") { [self]
            (ctxAction, view, completionHandler) in
            self.presenter.deleteCellButton(indexPath: indexPath)
            completionHandler(true)
        }

        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
        deleteAction.image = trashImage
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
    
}

extension FavOfTravelViewController: FavOfTravelPresenterOutput{
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func goToWebVC(url: String) {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "webVC") as! WebViewController
        webVC.url = url
        self.present(webVC, animated: true, completion: nil)
    }
    
    func deleteFavShop(indexPath:IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    
}


