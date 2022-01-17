//
//  TravelSearchViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

class TravelSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
