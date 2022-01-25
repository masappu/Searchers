//
//  PlaceSearchViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit
import GooglePlaces

class PlaceSearchViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var autocompleteController = GMSAutocompleteViewController()
    var placeSearchDataModel = PlaceSearchDataModel()
    private var presenter: PlaceSearchPresenterInput!
    private var pickerView: DistanceCell?
    private var isPickerViewShowing = false
    
    func inject(presenter:PlaceSearchPresenterInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = PlaceSearchPresenter(view:self)
        inject(presenter: presenter)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadView(Data: self.placeSearchDataModel)
        self.navigationItem.title = "目的地"
    }
    
    @objc func searchButton(_ sender: UIButton){
        self.presenter.searchButton()
    }
    
    @IBAction func doneButton(_ sender: Any) {
    }

}

// MARK: - PlaceSearchPresenterOutput
extension PlaceSearchViewController: PlaceSearchPresenterOutput{

    
    func setTableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(UINib(nibName: "PlaceSearchCell", bundle: nil), forCellReuseIdentifier: "PlaceSearchCell")
        tableView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
        tableView.register(UINib(nibName: "DistanceCell", bundle: nil), forCellReuseIdentifier: "DistanceCell")
    }
    
    func reloadTableView(){
        tableView.reloadData()
    }
    
    func startGooglePlaces() {
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    func AutocompleteControllerDismiss(selectedData: PlaceSearchDataModel) {
        self.placeSearchDataModel = selectedData
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func pickerViewIsHidden() {
        self.tableView.beginUpdates()
        if isPickerViewShowing{
            pickerView?.hidePicker()
        }else{
            pickerView?.showPicker()
        }
        self.isPickerViewShowing.toggle()
        self.tableView.endUpdates()
    }
    
    func reloadDistanceLabel() {
        self.tableView.beginUpdates()
        pickerView?.distanceLabel.text = String(self.presenter.placeData.searchRange) + "m 以内"
        self.tableView.endUpdates()
    }
    
}

// MARK: - TableView
extension PlaceSearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0{
//            return 80
//        }else if indexPath.section == 1{
//            return 170
//        }else{
//            return 400
//        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceSearchCell", for: indexPath) as! PlaceSearchCell
            cell.button.addTarget(self, action: #selector(self.searchButton(_:)), for: .touchUpInside)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
                cell.placeLabel.text = placeSearchDataModel.name
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
            self.pickerView = cell
            cell.inject(presenter: self.presenter)
            cell.distanceLabel.text = String(placeSearchDataModel.searchRange) + "m 以内"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectCell(index: indexPath.section)
    }
    
    
}

// MARK: - GMSAutocompleteViewController
extension PlaceSearchViewController: GMSAutocompleteViewControllerDelegate{
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.presenter.searchData(name: place.name!, longitude: place.coordinate.longitude, latitude: place.coordinate.latitude)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        true
    }
    
    
}
