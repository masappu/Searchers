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
    
    let buttonAnimat = ButtonAnimatedModel(animatType: .countCellButton)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.plusButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        self.plusButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        
        self.minusButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        self.minusButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func touchDown(_ sender:UIButton){
        self.buttonAnimat.touchDown(sender: sender)
    }

    @objc func touchUpOutside(_ sender:UIButton){
        self.buttonAnimat.touchUpOutside(sender: sender)
    }
    

}
