//
//  MemberCountCell.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/11.
//

import UIKit

class MemberCountCell: UITableViewCell {
    
    @IBOutlet weak var memberCountLabel: UILabel!
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
