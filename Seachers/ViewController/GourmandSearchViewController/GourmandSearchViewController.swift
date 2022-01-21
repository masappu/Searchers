//
//  GourmandSearchViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

protocol GourmandSearchViewInput{

    //tableViewのframe更新を要求する
    func requestTableViewLayoutRebuilding()
    
    //GenreデータのdeleteButtonタップを通知する
    func pushDeleteButton(at row:Int)
    
}

protocol GourmandSearchViewOutput{
    
    //collectionView構築のタイミングを指示
    func loadCollectionView()
    
    //collectionViewのdeleteRows()の実行を指示する
    func reloadDeleteRows(at indexPaths:[IndexPath])
    
    //collectionViewのreloadData()の実行を指示する
    func reloadData()
    
}


class GourmandSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchDate = GourmandSearchDataModel()

    private var isDatePickerShowing = false
    private var PickerCell:ReservationDateCell?
    private var memberCountCell:MemberCountCell?
    private var presenter:GourmandSearchInput!
    private var selectGenreCell:GourmandSearchViewOutput!

    func injectPresenter(presenter:GourmandSearchInput){
        self.presenter = presenter
    }
    
    func injectSelectGenreCell(cell:GourmandSearchViewOutput){
        self.selectGenreCell = cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = GourmandSearchPresenter(view: self)
        injectPresenter(presenter: presenter)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadView(Data: self.searchDate)
    }

    @IBAction func goMapView(_ sender: Any) {
        self.presenter.pushSearchButton()
    }

    @objc func plusButton(){
        self.presenter.pushPlusButton()
    }

    @objc func minusButton(){
        self.presenter.pushMinusButton()
    }

    @objc func datePickerValueDidChange(){
        self.presenter.datePickerValueChange(date: (self.PickerCell?.datePicker.date)!)
    }
}

extension GourmandSearchViewController:GourmandSearchOutput{

    func setTableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(UINib(nibName: "SelectDestinationCell", bundle: nil), forCellReuseIdentifier: "selectDestinationCell")
        tableView.register(UINib(nibName: "SelectGenreCell", bundle: nil), forCellReuseIdentifier: "selectGenreCell")
        tableView.register(UINib(nibName: "ReservationDateCell", bundle: nil), forCellReuseIdentifier: "reservationDateCell")
        tableView.register(UINib(nibName: "MemberCountCell", bundle: nil), forCellReuseIdentifier: "mamberCountCell")
    }
    
    func setNavigationControllerInfo() {
        self.navigationItem.title = "グルメ検索"
    }

    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func reloadSelectGenreCell(at indexPaths: [IndexPath]) {
        self.selectGenreCell.reloadDeleteRows(at: indexPaths)
    }

    func reloadMemberCountLabel() {
        self.tableView.beginUpdates()
        memberCountCell?.memberCountLabel.text = String(self.presenter.searchData.memberCount) + "名"
        self.tableView.endUpdates()
    }

    func reloadResevationDateLabel() {
        self.tableView.beginUpdates()
        self.PickerCell?.rserevationDateLabel.text = self.presenter.searchData.date.dateString
        self.tableView.endUpdates()
    }

    func reloadDatePickerIsHidden() {
        self.tableView.beginUpdates()
        if self.isDatePickerShowing{
            PickerCell?.hidePicker()
        }else{
            PickerCell?.showPicker()

        }
        self.isDatePickerShowing.toggle()
        self.tableView.endUpdates()
    }

    func transitionToMapView(Data: GourmandSearchDataModel) {
        let storyboard = UIStoryboard(name: "MapView", bundle: nil)
        let mapVC = storyboard.instantiateInitialViewController() as! MapViewController
        mapVC.gourmandSearchData = Data
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

    func transitionToPlaceSearchVIew() {
        let storyboard = UIStoryboard(name: "PlaceSearch", bundle: nil)
        let placeSearchVC = storyboard.instantiateInitialViewController() as! PlaceSearchViewController
        self.navigationController?.pushViewController(placeSearchVC, animated: true)
    }

    func transitionToGourmandGenreView(selectedGenres:[GenreModel]) {
        let gourmandGenreVC = self.storyboard?.instantiateViewController(withIdentifier: "gourmandGenreVC") as! GourmandGenreViewController
        gourmandGenreVC.popVC = self
        gourmandGenreVC.selecteGenres = selectedGenres
        self.navigationController?.pushViewController(gourmandGenreVC, animated: true)
    }

}

extension GourmandSearchViewController:GourmandGenreViewOutput{
    
    func passData(data: [GenreModel]) {
        self.searchDate.genre = data
    }
}

extension GourmandSearchViewController:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return GourmandSearchCellType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = GourmandSearchCellType(rawValue: indexPath.section)
        switch (cellType)! {
        case .selectDestinationCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! SelectDestinationCell
            let placeLabel = cell.contentView.viewWithTag(1) as! UILabel
            placeLabel.text = self.presenter.searchData.place.name
            return cell
        case .selectGenreCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! SelectGenreCell
            cell.inject(view: self, dataSource: self.presenter)
            self.injectSelectGenreCell(cell: cell)
            self.selectGenreCell.loadCollectionView()
            self.tableView.layoutIfNeeded()
            return cell
        case .reservationDateCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! ReservationDateCell
            self.PickerCell = cell
            self.PickerCell!.rserevationDateLabel.text = self.presenter.searchData.date.dateString
            self.PickerCell?.datePicker.date = self.presenter.searchData.date.date
            self.PickerCell?.datePicker.addTarget(self, action: #selector(datePickerValueDidChange), for: .valueChanged)
            return cell
        case .mamberCountCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! MemberCountCell
            self.memberCountCell = cell
            cell.selectionStyle = .none
            self.memberCountCell?.memberCountLabel.text = String(self.presenter.searchData.memberCount) + "名"
            self.memberCountCell?.plusButton.addTarget(self, action: #selector(plusButton), for: .touchUpInside)
            self.memberCountCell?.minusButton.addTarget(self, action: #selector(minusButton), for: .touchUpInside)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelsctCell(index: indexPath.section)
    }
}

extension GourmandSearchViewController:GourmandSearchViewInput{
    
    func requestTableViewLayoutRebuilding() {
        self.tableView.beginUpdates()
        self.tableView.layoutIfNeeded()
        self.tableView.endUpdates()
    }
    
    func pushDeleteButton(at row: Int) {
        self.presenter.deleteGenreData(indexPath: row)
    }
}
