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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NetShoppingTableViewCell", bundle: nil), forCellReuseIdentifier: "NetShoppingCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillApper()
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
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
   
    func addToFavoritesButton(_ sender: UIButton) {
        print(sender.superview?.superview?.superview?.superview)
        let cell = sender.superview?.superview?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
      //  presenter.addToFavoritesButton(indexPath: indexPath!)
    }
    
    func goToWebBotton(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
     //   presenter.goToWebVCButton(indexPath: indexPath!)
    }
    
    
    func setTableViewInfo() {
        
    }
    
    func reloadTableView() {
        tableView.reloadData()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == 0 {
//            return 1
//        }else{

           return presenter.productDataArray.count
        //}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetShoppingCell", for: indexPath) as! NetShoppingTableViewCell
        
        let productDataArray = presenter.productDataArray
        
        cell.ProductImage?.sd_setImage(with: URL(string: productDataArray[indexPath.row].product_image!), completed: nil)
        cell.NameLabel?.text = productDataArray[indexPath.row].name!
        cell.PriceLabel.text = String(productDataArray[indexPath.row].price!)
        cell.FavoriteButtom.addTarget(self, action: #selector(method), for: .touchUpInside)
        
        return cell
    }
    
    func tableViewfooter(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        label.text = "TEST TEXT"
        label.textColor = UIColor.red
        self.view.addSubview(view)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
    //ヘッダーにするビューを生成
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
            view.backgroundColor = UIColor.red
    //ヘッダーに追加するラベルを生成
            let headerLabel = UILabel()
            headerLabel.frame =  CGRect(x: 0, y: 1, width: self.view.frame.size.width, height: 25)
            headerLabel.text = "最安値"
            headerLabel.textColor = UIColor.white
            headerLabel.textAlignment = NSTextAlignment.center
            view.addSubview(headerLabel)
    return view
        }
    
}
