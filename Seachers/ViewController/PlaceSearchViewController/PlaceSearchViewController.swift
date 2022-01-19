//
//  PlaceSearchViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

class PlaceSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var presenter: PlaceSearchPresenterInput!
    func inject(presenter:PlaceSearchPresenterInput){
        self.presenter = presenter
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.loadView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Navigation
extension PlaceSearchViewController: PlaceSearchPresenterOutput{
    
    func setTableViewInfo() {
        tableView.register(UINib(nibName: "PlaceSearchCell", bundle: nil), forCellReuseIdentifier: "PlaceSearchCell")
        tableView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
        tableView.register(UINib(nibName: "DistanceCell", bundle: nil), forCellReuseIdentifier: "DistanceCell")
        tableView.delegate = self
        tableView.dataSource = self
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
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
            cell.placeLabel.text = "未選択"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
            cell.distanceLabel.text = "○○○○m　以内"
            return cell
        }
    }
    
    
}
