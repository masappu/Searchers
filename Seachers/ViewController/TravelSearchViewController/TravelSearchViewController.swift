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
    private var datePicker: ReservationDateCell!
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
        
        presenter.loadView()
        self.navigationItem.title = "旅行・宿検索"
    }
    
    
    
    @IBAction func goPlaceSearchVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PlaceSearch", bundle: nil)
        let placeSearchVC = storyboard.instantiateInitialViewController() as! PlaceSearchViewController
        self.navigationController?.pushViewController(placeSearchVC, animated: true)
    }
    
    
    @IBAction func goMapView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MapView", bundle: nil)
        let mapVC = storyboard.instantiateInitialViewController() as! MapViewController
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

}


// MARK: - TravelSearchPresenterOutput
extension TravelSearchViewController: TravelSearchPresenterOutput{
    
    
    func setTableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "SelectDestinationCell", bundle: nil), forCellReuseIdentifier: "selectDestinationCell")
        tableView.register(UINib(nibName: "ReservationDateCell", bundle: nil), forCellReuseIdentifier: "reservationDateCell")
        tableView.register(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "roomTableViewCell")
        tableView.register(UINib(nibName: "MemberCountCell", bundle: nil), forCellReuseIdentifier: "memberCountCell")
    }
    
    func transitionToPlaceSearchView() {
        let storyboard = UIStoryboard(name: "PlaceSearch", bundle: nil)
        let placeSearchVC = storyboard.instantiateInitialViewController() as! PlaceSearchViewController
        self.navigationController?.pushViewController(placeSearchVC, animated: true)
    }
    
    func datePickerOfCheckInIsHidden() {
        self.tableView.beginUpdates()
        if datePickerCheckInShowing{
            datePicker.hidePicker()
        }else{
            datePicker.showPicker()
        }
        self.datePickerCheckInShowing.toggle()
        self.tableView.endUpdates()
    }
    
    func datePickerOfCheckOutIsHidden() {
        self.tableView.beginUpdates()
        if datePickerCheckOutShowing{
            datePicker.hidePicker()
        }else{
            datePicker.showPicker()
        }
        self.datePickerCheckOutShowing.toggle()
        self.tableView.endUpdates()
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
            return 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = TravelSearchCellType(rawValue: indexPath.section)
        switch (cellType)! {
        case .selectDestinationCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! SelectDestinationCell
            return cell
        case .reservationDateCell:
            let cellType = ReservationDateCellType(rawValue: indexPath.row)
            switch (cellType)! {
            case .checkInCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! ReservationDateCell
                self.datePicker = cell
                return cell
            case .checkOutCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! ReservationDateCell
                self.datePicker = cell
                return cell
            }
        case .roomTableViewCell:
            let cellType = RoomTableViewCellType(rawValue: indexPath.row)
            switch (cellType)! {
            case .roomTableViewCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! RoomTableViewCell
                return cell
            case .numberOfroomsCountCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! MemberCountCell
                return cell
            case .numberOfmamberCountCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType!.cellIdentifier) as! MemberCountCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectCell(indexPath_row: indexPath.row, indexPath_section: indexPath.section)
    }
    
    
}
