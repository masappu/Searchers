//
//  ViewController.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/09.
//

import UIKit

class ViewController: UIViewController {
    
    private var placeSearchPresenter: PlaceSearchPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placeSearchPresenter.viewDidLoad()
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
