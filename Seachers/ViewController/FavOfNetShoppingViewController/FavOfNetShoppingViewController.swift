//
//  FavOfNetShoppingViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

class FavOfNetShoppingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
        presenter.viewwillAppear(didSelectCell: tableView.indexPathForSelectedRow)
    }
    
}

extension FavOfNetShoppingViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favProductDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favNetShoppingCell", for: indexPath)
        print("section：\(indexPath.section),row:\(indexPath.row)")
        
        let productDataArray = presenter.favProductDataArray
        
        
        let ProductImage = cell.contentView.viewWithTag(1) as! UIImageView
        ProductImage.sd_setImage(with: URL(string: productDataArray[indexPath.row].product_image), completed: nil)
        let NameLabel = cell.contentView.viewWithTag(2) as! UILabel
        NameLabel.text? = productDataArray[indexPath.row].name
        let PriceLabel = cell.contentView.viewWithTag(3) as! UILabel
        PriceLabel.text? = "¥\(productDataArray[indexPath.row].price)"
        
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
    
    func deleteFavProduct(indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "NetShoppingTableViewCell", bundle: nil), forCellReuseIdentifier: "NetShoppingCell")
    }
    
    func goToWebVC(url: String) {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "webVC") as! WebViewController
        webVC.url = url
        self.present(webVC, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func highlightDelete(indexPath:IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
