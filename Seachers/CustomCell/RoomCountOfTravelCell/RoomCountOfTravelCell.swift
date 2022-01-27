//
//  RoomCountOfTravelCell.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/26.
//

import UIKit

class RoomCountOfTravelCell: UITableViewCell {
    
    
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
