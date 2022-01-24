//
//  RoomTableViewCell.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/21.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberOfPeople: UILabel!
    @IBOutlet weak var numberOfRooms: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

