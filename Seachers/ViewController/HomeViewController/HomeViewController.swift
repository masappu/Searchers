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
        let storyboard = UIStoryboard(name: "NetShopping", bundle: nil)
        let NetShopVC = storyboard.instantiateViewController(withIdentifier: "NetShopVC") as! NetShoppingViewController
        navigationController?.pushViewController(NetShopVC, animated: true)
    }
    
    @IBAction func goGourmadSearchVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "GourmandSearch", bundle: nil)
        let gourmandSearchVC = storyboard.instantiateViewController(withIdentifier: "gourmandSearchVC") as! GourmandSearchViewController
        navigationController?.pushViewController(gourmandSearchVC, animated: true)
    }
    
    

}

