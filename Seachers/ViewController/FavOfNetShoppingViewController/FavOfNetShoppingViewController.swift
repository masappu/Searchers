//
//  FavOfNetShoppingViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

class FavOfNetShoppingViewController: UIViewController {

    //↓storyBoardを作って繋げてください
//    @IBOutlet weak var tableView: UITableView!
    //↑storyBoardを作って繋げてください
    
    private var presenter:FavOfNetShoppingPresenterInput!
    
    func inject(presenter:FavOfNetShoppingPresenter){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let presenter = FavOfNetShoppingPresenter(view: self)
        inject(presenter: presenter)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewwillAppear()
    }

}

extension FavOfNetShoppingViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favShopDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //↓storyBoardを作ってIDを変更してください
        let cell = tableView.dequeueReusableCell(withIdentifier: "favGourmandCell", for: indexPath)
        //↑storyBoardを作ってIDを変更してください
        
        //↓storyBoardを作って変えてください
        let shopImage = cell.contentView.viewWithTag(1) as! UIImageView
        let genreNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let nameLabel = cell.contentView.viewWithTag(3) as! UILabel
        let budgetAverageLabel = cell.contentView.viewWithTag(4) as! UILabel
        let lunchLabel = cell.contentView.viewWithTag(5) as! UILabel
        
        let favShopDataArray = presenter.favShopDataArray
        shopImage.sd_setImage(with: URL(string: favShopDataArray[indexPath.row].shop_image))
        genreNameLabel.text = favShopDataArray[indexPath.row].smallAreaName + "/" + favShopDataArray[indexPath.row].genreName
        nameLabel.text = favShopDataArray[indexPath.row].name
        budgetAverageLabel.text = favShopDataArray[indexPath.row].budgetAverage
        lunchLabel.text = favShopDataArray[indexPath.row].lunch
        //↑storyBoardを作って変えてください
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
        
}

extension FavOfNetShoppingViewController: UITableViewDelegate{
    
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

extension FavOfNetShoppingViewController: FavOfNetShoppingPresenterOutput{
    
    func setupTableView() {
        //↓tableViewを繋げてコメントアウトを外してください
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
        //↑tableViewを繋げてコメントアウトを外してください
    }
    
    func goToWebVC(url: String) {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "webVC") as! WebViewController
        webVC.url = url
        self.present(webVC, animated: true, completion: nil)
    }
    
    func deleteFavShop(indexPath:IndexPath) {
        //↓tableViewを繋げてコメントアウトを外してください
//        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        //↑tableViewを繋げてコメントアウトを外してください
    }
    
    func reloadTableView() {
        
    }
    
}
