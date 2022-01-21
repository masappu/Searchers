//
//  GourmandCategoryViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

protocol GourmandGenreViewOutput{

    //値を渡しのためのメソッド
    func passData(data:[GenreModel])
    
}

class GourmandGenreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var presenter:GourmandGenrePresenterInput?
     var popVC:GourmandGenreViewOutput?
    var selecteGenres = [GenreModel]()
    
    func inject(presenter:GourmandGenrePresenterInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = GourmandGenrePresenter(view: self)
        inject(presenter: presenter)
        self.presenter?.loadView(selectedDate:self.selecteGenres)
    }
    
    @objc func selectedButton(_ sender:UIButton){
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        self.presenter?.pushSelectedButton(indexPath: indexPath!)
    }
    
    @objc func clearButton(){
        self.presenter?.pushClearButton()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.presenter?.pushDoneButton()
    }
    
}

extension GourmandGenreViewController:GourmandGenrePresenterOutput{
    func setTableViewInfo() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setNavigationItemInfo() {
        self.title = "ジャンル"
        
        let clearButtonItem = UIBarButtonItem(title: "クリア", style: .done, target: self, action: #selector(clearButton))
        self.navigationItem.rightBarButtonItems = [clearButtonItem]
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func reloadSelectedButton(at indexArray:[IndexPath]) {
        self.tableView.reloadRows(at: indexArray, with: .fade)
    }
    
    func goBack(selectedData: [GenreModel]) {
        self.popVC?.passData(data: selectedData)
        self.navigationController?.popViewController(animated: true)
    }
}

extension GourmandGenreViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.presenter?.allGenreData.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let genreLabel = cell.contentView.viewWithTag(1) as! UILabel
        let selectButton = cell.contentView.viewWithTag(2) as! UIButton
        cell.selectionStyle = .none
        
        genreLabel.text = self.presenter?.allGenreData[indexPath.row].name
        
        selectButton.addTarget(self, action: #selector(selectedButton(_:)), for: .touchUpInside)
        selectButton.imageView?.image = UIImage(systemName: (self.presenter?.allGenreData[indexPath.row].selectbuttonImageID)!)
        selectButton.imageView?.tintColor = (self.presenter?.allGenreData[indexPath.row].selectButtonImageColor)!
        
        return cell
    }
}
