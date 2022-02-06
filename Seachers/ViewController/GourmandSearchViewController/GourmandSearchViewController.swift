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
        presenter.loadView()
    }
    
    @IBAction func goMapView(_ sender: Any) {
        self.presenter.pushSearchButton()
    }
    
    @objc func plusButton(_ sender:UIButton){
        self.presenter.pushPlusButton()
    }
    
    @objc func minusButton(_ sender:UIButton){
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
        tableView.separatorColor = UIColor(red: self.presenter.rgb.r, green: self.presenter.rgb.g, blue: self.presenter.rgb.b, alpha: self.presenter.rgb.alpha)
        
        tableView.register(UINib(nibName: "SelectDestinationCell", bundle: nil), forCellReuseIdentifier: "selectDestinationCell")
        tableView.register(UINib(nibName: "SelectGenreCell", bundle: nil), forCellReuseIdentifier: "selectGenreCell")
        tableView.register(UINib(nibName: "NonSelectGenreCell", bundle: nil), forCellReuseIdentifier: "nonSelectGenreCell")
        tableView.register(UINib(nibName: "ReservationDateCell", bundle: nil), forCellReuseIdentifier: "reservationDateCell")
        tableView.register(UINib(nibName: "MemberCountCell", bundle: nil), forCellReuseIdentifier: "memberCountCell")
        
    }
    
    func setNavigationControllerInfo() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: self.presenter.rgb.r, green: self.presenter.rgb.g, blue: self.presenter.rgb.b, alpha: self.presenter.rgb.alpha)
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.title = "グルメ検索"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    func reloadSelectGenreCell(at indexPaths: [IndexPath]) {
        self.selectGenreCell.reloadDeleteRows(at: indexPaths)
    }
    
    func reloadTableViewCell(at IndexPaths: [IndexPath]) {
        self.tableView.reloadRows(at: IndexPaths, with: .fade)
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
    
    func transitionToMapView(Data:GourmandSearchDataModel, previousVCString:String) {
        let storyboard = UIStoryboard(name: "MapView", bundle: nil)
        let mapVC = storyboard.instantiateInitialViewController() as! MapViewController
        mapVC.gourmandSearchData = Data
        mapVC.previousVCString = previousVCString
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func transitionToPlaceSearchView() {
        let storyboard = UIStoryboard(name: "PlaceSearch", bundle: nil)
        let placeSearchVC = storyboard.instantiateInitialViewController() as! PlaceSearchViewController
        placeSearchVC.placeSearchViewOutput = self
        placeSearchVC.transitionSourceName = "Gourmand"
        self.navigationController?.pushViewController(placeSearchVC, animated: true)
    }
    
    func transitionToGourmandGenreView(selectedGenres:[GenreViewModel]) {
        let gourmandGenreVC = self.storyboard?.instantiateViewController(withIdentifier: "gourmandGenreVC") as! GourmandGenreViewController
        gourmandGenreVC.popVC = self
        gourmandGenreVC.selecteGenres = selectedGenres
        self.navigationController?.pushViewController(gourmandGenreVC, animated: true)
    }
    
    func showAlertLocationIsEmpty() {
        let alert = UIAlertController(title: "目的地が選択されていません。", message: "目的地を選択するか、位置情報の取得を許可してください。", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel,handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension GourmandSearchViewController:GourmandGenreViewOutput{
    
    func passData(data: [GenreViewModel]) {
        self.presenter.searchData.genre = data
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
            let searchRangeLabel = cell.contentView.viewWithTag(2) as! UILabel
            placeLabel.text = self.presenter.searchData.place.name
            searchRangeLabel.text = "検索範囲を" + self.presenter.searchData.place.searchRange!.searchRangeLabelText + "に設定中"
            return cell
        case .selectGenreCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! SelectGenreCell
            cell.inject(view: self, dataSource: self.presenter)
            self.injectSelectGenreCell(cell: cell)
            self.selectGenreCell.loadCollectionView()
            return cell
        case .reservationDateCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! ReservationDateCell
            cell.selectionStyle = .none
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
            self.memberCountCell?.plusButton.addTarget(self, action: #selector(plusButton(_:)), for: .touchUpInside)
            self.memberCountCell?.minusButton.addTarget(self, action: #selector(minusButton(_:)), for: .touchUpInside)
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

extension GourmandSearchViewController:PlaceSearchViewOutput{
    func passData(Data: PlaceSearchDataModel) {
        self.presenter.searchData.place.name = Data.name
        self.presenter.searchData.place.locaitonAtSearchPlace = Data.locaitonAtSearchPlace
        self.presenter.searchData.place.searchRange = Data.searchRange
    }
}
