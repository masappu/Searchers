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
    @IBOutlet weak var containerView: NSLayoutConstraint!
    
    static let compressedHeight:CGFloat = 55
    static let expandedHeight:CGFloat = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.constant = CheckInCell.compressedHeight
        datePicker.isHidden = true
        datePicker.alpha = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
