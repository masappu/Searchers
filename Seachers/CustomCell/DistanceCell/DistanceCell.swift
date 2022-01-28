//
//  DistanceCell.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/14.
//

import UIKit

class DistanceCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var presenter: PlaceSearchPresenterInput!
    func inject(presenter: PlaceSearchPresenterInput){
        self.presenter = presenter
    }

    var list = [String]()
    static let compressedHeight: CGFloat = 90
    static let expandedHeight: CGFloat = 250
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        containerViewHeight.constant = DistanceCell.compressedHeight
        pickerView.isHidden = true
        pickerView.alpha = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func showPicker(){
        guard pickerView.isHidden else {return}
        
        // セルの高さの制約の値を変更して、Pickerが見えるようにする
        containerViewHeight.constant = DistanceCell.expandedHeight
        pickerView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.pickerView.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func hidePicker(){
        guard !pickerView.isHidden else {return}
        
        // セルの高さの制約の値を変更して、Pickerが隠れるようにする
        containerViewHeight.constant = DistanceCell.compressedHeight
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.alpha = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.pickerView.isHidden = true
        })

           
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.presenter.didSelectPickerData(selectedData: list[row])
    }
    
}
