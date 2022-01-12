//
//  GourmandSearchViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

protocol CellType{
    //cellを一元管理する変数
    var cellIdentifier: String {get}
}

class GourmandSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchDate = GourmandSearchDataModel()
    
    private var isDatePickerShowing = false
    private var PickerCell:ReservationDateCell?
    private var memberCountCell:MemberCountCell?
    private var presenter:GourmandSearchInput!
        
    func inject(presenter:GourmandSearchInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = GourmandSearchPresenter(view: self)
        inject(presenter: presenter)
        self.navigationItem.title = "グルメ検索"
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
    
    func reloadTableView() {
        self.tableView.reloadData()
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
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func transitionToPlaceSearchVIew() {
        let storyboard = UIStoryboard(name: "PlaceSearch", bundle: nil)
        let placeSearchVC = storyboard.instantiateInitialViewController() as! PlaceSearchViewController
        self.navigationController?.pushViewController(placeSearchVC, animated: true)
    }
    
    func transitionToGourmandGenreView() {
        let gourmandGenreVC = self.storyboard?.instantiateViewController(withIdentifier: "gourmandGenreVC") as! GourmandGenreViewController
        self.navigationController?.pushViewController(gourmandGenreVC, animated: true)
    }
    
}

extension GourmandSearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return GourmandSearchCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = GourmandSearchCellType(rawValue: indexPath.section)
        switch (cellType)! {
        case .selectDestinationCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! SelectDestinationCell
            let placeLabel = cell.contentView.viewWithTag(1) as! UILabel
            placeLabel.text = self.searchDate.place.name
            return cell
        case .selectGenreCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! SelectGenreCell
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


enum GourmandSearchCellType: Int, CaseIterable, CellType{
    case selectDestinationCell
    case selectGenreCell
    case reservationDateCell
    case mamberCountCell
    
    var cellIdentifier: String{
        switch self {
        case .selectDestinationCell: return "selectDestinationCell"
        case .selectGenreCell: return "selectGenreCell"
        case .reservationDateCell: return "reservationDateCell"
        case .mamberCountCell: return "mamberCountCell"
        }
    }
}
