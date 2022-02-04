//
//  PlaceSearchViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit
import GooglePlaces

protocol PlaceSearchViewOutput{
    func passData(Data:PlaceSearchDataModel)
}

class PlaceSearchViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    var autocompleteController = GMSAutocompleteViewController()
    var placeSearchViewOutput: PlaceSearchViewOutput!
    var presenter: PlaceSearchPresenterInput!
    var transitionSourceName = String()
    private var pickerView: DistanceCell?
    private var isPickerViewShowing = false
    func inject(presenter:PlaceSearchPresenterInput){
        self.presenter = presenter
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = PlaceSearchPresenter(view:self, initialValue:transitionSourceName)
        inject(presenter: presenter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadView(transitionSourceName: transitionSourceName)
    }
    
    @objc func searchButton(_ sender: UIButton){
        self.presenter.searchButton()
    }
    
    @objc func touchDown(_ sender: UIButton){
        self.presenter.buttonAnimation.startAnimation(sender: sender)
    }
    
    @objc func touchUpOutside(_ sender: UIButton){
        self.presenter.buttonAnimation.endAnimation(sender: sender)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.presenter.buttonAnimation.endAnimation(sender: sender as! UIButton)
        self.presenter.pushDoneButton()
    }
    

}

// MARK: - PlaceSearchPresenterOutput
extension PlaceSearchViewController: PlaceSearchPresenterOutput{

    
    func setTableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor(red: self.presenter.rgb.r, green: self.presenter.rgb.g, blue: self.presenter.rgb.b, alpha: self.presenter.rgb.alpha)
        tableView.register(UINib(nibName: "PlaceSearchCell", bundle: nil), forCellReuseIdentifier: "PlaceSearchCell")
        tableView.register(UINib(nibName: "DistanceCell", bundle: nil), forCellReuseIdentifier: "DistanceCell")
    }
    
    func setNavigationControllerInfo() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: self.presenter.rgb.r, green: self.presenter.rgb.g, blue: self.presenter.rgb.b, alpha: self.presenter.rgb.alpha)
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.title = "目的地"
    }
    
    func setButton() {
        
        button.backgroundColor = UIColor(red: self.presenter.rgb.r, green: self.presenter.rgb.g, blue: self.presenter.rgb.b, alpha: self.presenter.rgb.alpha)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.layer.cornerRadius = 40.0
        button.layer.shadowColor = UIColor(red: self.presenter.rgb.r, green: self.presenter.rgb.g, blue: self.presenter.rgb.b, alpha: self.presenter.rgb.alpha).cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)

    }
    
    func reloadTableView(){
        tableView.reloadData()
    }
    
    func startGooglePlaces() {
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    func AutocompleteControllerDismiss(selectedData: PlaceSearchDataModel) {
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
        pickerView?.distanceLabel.text =  self.presenter.placeData.searchRange!.searchRangeLabelText + "以内"
        self.tableView.endUpdates()
    }
    
    func goBack(selectedData: PlaceSearchDataModel) {
        self.placeSearchViewOutput?.passData(Data: selectedData)
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TableView
extension PlaceSearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceSearchCell", for: indexPath) as! PlaceSearchCell
            cell.selectionStyle = .none
            cell.placeLabel.text = self.presenter.placeData.name
            cell.button.addTarget(self, action: #selector(self.searchButton(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
            cell.selectionStyle = .none
            self.pickerView = cell
            cell.inject(presenter: self.presenter)
            cell.list = self.presenter.pickerList
            cell.distanceLabel.text =  presenter.placeData.searchRange!.searchRangeLabelText + "以内"
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
        self.presenter.searchData(name: place.name!, place: place.coordinate)
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
