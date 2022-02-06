//
//  NetShoppingViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class NetShoppingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var presenter:NetShoppingPresenterInput!
    
    func inject(presenter:NetShoppingPresenter){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = NetShoppingPresenter(view: self)
        inject(presenter: presenter)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillApper()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    @objc func addToFavoritesButton(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        presenter.addToFavoritesButton(indexPath: indexPath!)
    }
    
}

extension NetShoppingViewController: UISearchBarDelegate{
    //検索バーで入力する時
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //キャンセルボタンを表示
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    //検索バーのキャンセルがタップされた時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //キャンセルボタンを非表示
        searchBar.showsCancelButton = false
        //キーボードを閉じる
        searchBar.resignFirstResponder()
    }
    
    
    //検索バーでEnterが押された時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarSearchButtonClicked(keyword: searchBar.text!)
    }
    
}

extension NetShoppingViewController: NetShoppingPresenterOutput{
    func showAlertError() {
        let alert = UIAlertController(title: "予期せぬエラーが発生しました。", message: "ネットワーク接続を確認し、アプリを再起動してください。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func goToWeb(url: String) {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "webVC") as! WebViewController
        webVC.url = url
        self.present(webVC, animated: true, completion: nil)
    }
    
    @objc func goToWebButton(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        presenter.goToWebButton(indexPath: indexPath!)
    }
    
    func addToFavorites(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func setTableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "NetShoppingTableViewCell", bundle: nil), forCellReuseIdentifier: "NetShoppingCell")
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showAlertResultEmpty() {
        let alert = UIAlertController(title: "検索結果が見つかりません。", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel,handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setSearchBar() {
        // NavigationBarにSearchBarをセット
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            //NavigationBarに適したサイズの検索バーを設置
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            //デリゲート
            searchBar.delegate = self
            //プレースホルダー
            searchBar.placeholder = "商品を検索"
            //検索バーのスタイル
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            //NavigationTitleが置かれる場所に検索バーを設置
            navigationItem.titleView = searchBar
            //NavigationTitleのサイズを検索バーと同じにする
            navigationItem.titleView?.frame = searchBar.frame
            
        }
    }
}


extension NetShoppingViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.productDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetShoppingCell", for: indexPath) as! NetShoppingTableViewCell
        print("section：\(indexPath.section),row:\(indexPath.row)")
        let productDataArray = presenter.productDataArray
        
        cell.ProductImage?.sd_setImage(with: URL(string: productDataArray[indexPath.row].NetShoppingData.product_image), completed: nil)
        cell.NameLabel?.text = productDataArray[indexPath.row].NetShoppingData.name
        cell.PriceLabel.text = "¥\(String(productDataArray[indexPath.row].NetShoppingData.price))"
        cell.FavoriteButton.addTarget(self, action: #selector(addToFavoritesButton(_:)), for: .touchUpInside)
        cell.FavoriteButton.imageView?.image = UIImage(systemName: productDataArray[indexPath.row].favProduct)
        cell.UrlButtom.addTarget(self, action: #selector(goToWebButton(_:)), for: .touchUpInside)
        cell.valuationLabel.text = productDataArray[indexPath.row].NetShoppingData.valuation
        
        return cell
    }
}
