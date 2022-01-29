//
//  TravelSearchViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

class TravelSearchViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: TravelSearchPresenterInput!
    private var datePickerOfCheckIn: CheckInCell!
    private var datePickerOfCheckOut:CheckOutCell!
    var travelSearchDataModel = TravelSearchDataModel()
    private var datePickerCheckInShowing = false
    private var datePickerCheckOutShowing = false

    func inject(presenter:TravelSearchPresenterInput){
        self.presenter = presenter
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let presenter = TravelSearchPresenter(view: self)
        inject(presenter: presenter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.loadView(Data: travelSearchDataModel)
    }
    
    
    @IBAction func goMapView(_ sender: Any) {
        self.presenter.doneButton()
    }
    
    @objc func datePickerOfCheckInValueChange(){
        self.presenter.datePickerOfCheckInValueChange(date: self.datePickerOfCheckIn.datePicker.date)
    }
    
    @objc func datePickerOfCheckOutValueChange(){
        self.presenter.datePickerOfCheckOutValueChange(date: self.datePickerOfCheckOut.datePicker.date)
    }
    
    @objc func roomPlusButton(_ sender: Any){
        self.presenter.roomPlusPushButton()
    }
    
    @objc func roomMinusButton(_ sender:Any){
        self.presenter.roomMinusPushButton()
    }
    
    @objc func memberPlusButton(_ sender:Any){
        self.presenter.memberPlusPushButton()
    }
    
    @objc func memberMinusButton(_ sender:Any){
        self.presenter.memberMinusPushButton()
    }

}

// MARK: - PlaceSearchViewOutput
extension TravelSearchViewController: PlaceSearchViewOutput{
    
    func passData(Data: PlaceSearchDataModel) {
        self.presenter.receiveData(Data: Data)
    }
}

// MARK: - TravelSearchPresenterOutput
extension TravelSearchViewController: TravelSearchPresenterOutput{
    
    
    func setTableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .green
        
        tableView.register(UINib(nibName: "SelectDestinationCell", bundle: nil), forCellReuseIdentifier: "selectDestinationCell")
        tableView.register(UINib(nibName: "CheckInCell", bundle: nil), forCellReuseIdentifier: "checkInCell")
        tableView.register(UINib(nibName: "CheckOutCell", bundle: nil), forCellReuseIdentifier: "checkOutCell")
        tableView.register(UINib(nibName: "RoomCountOfTravelCell", bundle: nil), forCellReuseIdentifier: "roomCountOfTravelCell")
        tableView.register(UINib(nibName: "MemberCountOfTravelCell", bundle: nil), forCellReuseIdentifier: "memberCountOfTravelCell")
    }
    
    func setNavigationControllerInfo() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .green
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.title = "旅行・宿検索"
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    func transitionToPlaceSearchView() {
        let storyboard = UIStoryboard(name: "PlaceSearch", bundle: nil)
        let placeSearchVC = storyboard.instantiateInitialViewController() as! PlaceSearchViewController
        placeSearchVC.placeSearchViewOutput = self
        placeSearchVC.transitionSourceName = "TravelSearch"
        self.navigationController?.pushViewController(placeSearchVC, animated: true)
        
    }
    
    func datePickerOfCheckInIsHidden() {
        self.tableView.beginUpdates()
        if datePickerCheckInShowing{
            datePickerOfCheckIn.hidePicker()
        }else{
            datePickerOfCheckIn.showPicker()
        }
        self.datePickerCheckInShowing.toggle()
        self.tableView.endUpdates()
    }
    
    func datePickerOfCheckOutIsHidden() {
        self.tableView.beginUpdates()
        if datePickerCheckOutShowing{
            datePickerOfCheckOut.hidePicker()
        }else{
            datePickerOfCheckOut.showPicker()
        }
        self.datePickerCheckOutShowing.toggle()
        self.tableView.endUpdates()
    }
    
    func reloadCheckInDateLabel() {
        self.tableView.beginUpdates()
        self.datePickerOfCheckIn.dateLabel.text = self.presenter.searchData.checkInDate.dateString
        self.datePickerOfCheckOut.datePicker.minimumDate = self.presenter.searchData.checkOutDate.changeDate
        self.datePickerOfCheckOut.dateLabel.text = self.presenter.searchData.checkOutDate.dateString
        self.presenter.searchData.checkOutDate.date = self.presenter.searchData.checkOutDate.changeDate
        self.tableView.endUpdates()
    }
    
    func reloadCheckOutDateLabel() {
        self.tableView.beginUpdates()
        self.datePickerOfCheckOut.dateLabel.text = self.presenter.searchData.checkOutDate.dateString
        self.tableView.endUpdates()
    }
    
    func goMapView() {
        let storyboard = UIStoryboard(name: "MapView", bundle: nil)
        let mapVC = storyboard.instantiateInitialViewController() as! MapViewController
        mapVC.previousVCString = "TravelSearchViewController"
        mapVC.travelSearchData = self.presenter.searchData
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    
}


// MARK: - TableView
extension TravelSearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 2
        }else{
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = TravelSearchCellType(rawValue: indexPath.section)
        switch (cellType)! {
        case .selectDestinationCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! SelectDestinationCell
            cell.destinationLabel.text = "検索範囲を" + (self.presenter.searchData.placeData?.searchRange!.searchRangeLabelText)! + "に設定中"
            cell.placeLabel.text = self.presenter.searchData.placeData?.name
            return cell
        case .checkCell:
            let cellType = CheckCellType(rawValue: indexPath.row)
            switch (cellType)! {
            case .checkInCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! CheckInCell
                cell.selectionStyle = .none
                self.datePickerOfCheckIn = cell
                self.datePickerOfCheckIn.dateLabel.text = self.presenter.searchData.checkInDate.dateString
//                self.datePickerOfCheckIn?.datePicker.date = self.presenter.searchData.checkInDate.date
                self.datePickerOfCheckIn.datePicker.addTarget(self, action: #selector(datePickerOfCheckInValueChange), for: .valueChanged)
                return cell
            case .checkOutCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! CheckOutCell
                cell.selectionStyle = .none
                self.datePickerOfCheckOut = cell
                self.datePickerOfCheckOut.dateLabel.text = self.presenter.searchData.checkOutDate.dateString
                self.datePickerOfCheckOut.datePicker.minimumDate = self.presenter.searchData.checkOutDate.date
                self.datePickerOfCheckOut.datePicker.addTarget(self, action: #selector(datePickerOfCheckOutValueChange), for: .valueChanged)
                return cell
            }
        case .roomAndMemberCell:
            let cellType = RoomAndMemberCellType(rawValue: indexPath.row)
            switch (cellType)! {
            case .numberOfroomsCountCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! RoomCountOfTravelCell
                cell.selectionStyle = .none
                cell.roomCountLabel.text = String(self.presenter.searchData.roomNum) + "部屋"
                cell.plusButton.addTarget(self, action: #selector(self.roomPlusButton(_:)), for: .touchUpInside)
                cell.minusButton.addTarget(self, action: #selector(self.roomMinusButton(_:)), for: .touchUpInside)
                return cell
            case .numberOfmemberCountCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! MemberCountOfTravelCell
                cell.selectionStyle = .none
                cell.memberCountLabel.text = String(self.presenter.searchData.adultNum) + "名"
                cell.plusButton.addTarget(self, action: #selector(self.memberPlusButton(_:)), for: .touchUpInside)
                cell.minusButton.addTarget(self, action: #selector(self.memberMinusButton(_:)), for: .touchUpInside)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectCell(indexPath_row: indexPath.row, indexPath_section: indexPath.section)
    }
    
    
}
