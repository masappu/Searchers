//
//  GourmandCategoryViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit

class GourmandGenreViewController: UIViewController {

    
    
    private var presenter:GourmandGenrePresenterInput?
    
    func inject(presenter:GourmandGenrePresenterInput){
        self.presenter = presenter
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = GourmandGenrePresenter(view: self)
        inject(presenter: presenter)
        self.presenter?.loadView()
        print(self.presenter?.allGenreData)
    }
    
}

extension GourmandGenreViewController:GourmandGenrePresenterOutput{
    func setTableViewInfo() {
        print("")
    }
    
    func reloadTableView() {
        print("")
    }
}
