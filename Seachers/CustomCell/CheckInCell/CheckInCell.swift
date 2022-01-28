//
//  CheckInCell.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/26.
//

import UIKit

class CheckInCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var conteinerViewHeight: NSLayoutConstraint!
    
    static let compressedHeight:CGFloat = 120
    static let expandedHeight:CGFloat = 340
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conteinerViewHeight.constant = CheckInCell.compressedHeight
        datePicker.isHidden = true
        datePicker.alpha = 0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func showPicker(){
        guard datePicker.isHidden else {return}
        
        // セルの高さの制約の値を変更して、Pickerが見えるようにする
        conteinerViewHeight.constant = CheckInCell.expandedHeight
        datePicker.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.datePicker.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func hidePicker() {
        guard !datePicker.isHidden else { return }
        
        // セルの高さの制約の値を変更して、Pickerが隠れるようにする
        conteinerViewHeight.constant = CheckInCell.compressedHeight
        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.datePicker.isHidden = true
        })
    }
    
}
