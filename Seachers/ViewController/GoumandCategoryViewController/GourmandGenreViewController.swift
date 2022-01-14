//
//  GourmandCategoryViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

class GourmandGenreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var presenter:GourmandGenrePresenterInput?
    
    func inject(presenter:GourmandGenrePresenterInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = GourmandGenrePresenter(view: self)
        inject(presenter: presenter)
        self.presenter?.loadView()
    }
    
    @objc func selectedButton(_ sender:UIButton){
        
    }
    
}

extension GourmandGenreViewController:GourmandGenrePresenterOutput{
    func setTableViewInfo() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension GourmandGenreViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.presenter?.allGenreData.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let genreLabel = cell.contentView.viewWithTag(1) as! UILabel
        let selectButton = cell.contentView.viewWithTag(2) as! UIButton
        
        genreLabel.text = self.presenter?.allGenreData[indexPath.row].name
        selectButton.addTarget(self, action: #selector(selectedButton(_:)), for: .touchUpInside)
        selectButton.tag = indexPath.row
        
        
        
        return cell
    }
}
