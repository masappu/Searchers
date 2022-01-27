//
//  RoomTableViewCell.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/21.
//

import UIKit

class RoomAndMemberCell: UITableViewCell {
    
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var roomCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

