//
//  PlaceCell.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/14.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        placeLabel.numberOfLines = 0
        // Configure the view for the selected state
    }
    
}
