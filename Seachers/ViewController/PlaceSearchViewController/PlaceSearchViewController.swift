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
    private var placeDataModel: PlaceDataModel!
    private var presenter: PlaceSearchPresenterInput!
    
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
        presenter.loadView()
        self.navigationItem.title = "目的地"
    }
    
    @objc func searchButton(_ sender: UIButton){
        self.presenter.searchButton()
    }
    

}

// MARK: - PlaceSearchPresenterOutput
extension PlaceSearchViewController: PlaceSearchPresenterOutput{
    
    
    func setTableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func AutocompleteControllerDismiss(selectedData: PlaceDataModel) {
        self.placeDataModel = selectedData
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
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
        if indexPath.section == 0{
            return 80
        }else if indexPath.section == 1{
            return 170
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceSearchCell", for: indexPath) as! PlaceSearchCell
            cell.button.addTarget(self, action: #selector(self.searchButton(_:)), for: .touchUpInside)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
            if placeDataModel == nil{
                cell.placeLabel.text = "未経験"
            }else{
                cell.placeLabel.text = placeDataModel.name
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
            cell.distanceLabel.text = "○○○○m　以内"
            return cell
        }
    }
    
    
}

// MARK: - GMSAutocompleteViewController
extension PlaceSearchViewController: GMSAutocompleteViewControllerDelegate{
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("************")
        print(place)
        let placeData = PlaceDataModel(name: place.name!, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.presenter.searchData(Data: placeData)
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
