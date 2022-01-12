//
//  ReservationDateCell.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/11.
//

import UIKit

class ReservationDateCell: UITableViewCell {
    
    

    @IBOutlet weak var conteinerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var rserevationDateLabel: UILabel!
    
    static let compressedHeight: CGFloat = 80
    static let expandedHeight: CGFloat = 300
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conteinerViewHeight.constant = ReservationDateCell.compressedHeight
        datePicker.isHidden = true
        datePicker.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
        func showPicker() {
            guard datePicker.isHidden else { return }
    
            // セルの高さの制約の値を変更して、Pickerが見えるようにする
            conteinerViewHeight.constant = ReservationDateCell.expandedHeight
            datePicker.isHidden = false
            print("width:\(self.frame.width),height:\(self.frame.height)")
            UIView.animate(withDuration: 0.25) {
                self.datePicker.alpha = 1
                self.layoutIfNeeded()
            }
        }
    
        func hidePicker() {
            guard !datePicker.isHidden else { return }
    
            // セルの高さの制約の値を変更して、Pickerが隠れるようにする
            conteinerViewHeight.constant = ReservationDateCell.compressedHeight
            print("width:\(self.frame.width),height:\(self.frame.height)")
            UIView.animate(withDuration: 0.25, animations: {
                self.datePicker.alpha = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.datePicker.isHidden = true
            })
        }
}


