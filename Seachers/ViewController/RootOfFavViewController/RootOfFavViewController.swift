//
//  RootOfFavViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/29.
//

import UIKit

class RootOfFavViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        let rgb = ColorType(rawValue: "Fav")?.rgb
        appearance.backgroundColor = UIColor(red: rgb!.r, green: rgb!.g, blue: rgb!.b, alpha: rgb!.alpha)
        
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.title = "お気に入り一覧"

        // Do any additional setup after loading the view.
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
