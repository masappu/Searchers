//
//  ViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/09.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func goNetShoppingVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NetShopping", bundle:nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let NetShopVC = navigationController.topViewController as! NetShoppingViewController
        self.navigationController?.pushViewController(NetShopVC, animated: true)
        
        
    }
    
    @IBAction func goGourmadSearchVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "GourmandSearch", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let gourmandSearchVC = navigationController.topViewController as! GourmandSearchViewController
        self.navigationController?.pushViewController(gourmandSearchVC, animated: true)

    }
    
    
    @IBAction func goTravelSearchVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TravelSearch", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let travelSearchVC = navigationController.topViewController as! TravelSearchViewController
        self.navigationController?.pushViewController(travelSearchVC, animated: true)

    }
    
    
    @IBAction func goFavView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FavView", bundle: nil)
        let tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
        tabBarController.selectedIndex = 0
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
}

