//
//  MemberCountOfTravelCell.swift
//  Seachers
//
//  Created by 都甲裕希 on 2022/01/26.
//

import UIKit

class MemberCountOfTravelCell: UITableViewCell {
    
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    let buttonAnimat = ButtonAnimatedModel(animatType: .countCellButton)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.plusButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        self.plusButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)

        self.minusButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        self.minusButton.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func touchDown(_ sender:UIButton){
        self.buttonAnimat.touchDown(sender: sender)
    }

    @objc func touchUpOutside(_ sender:UIButton){
        self.buttonAnimat.touchUpOutside(sender: sender)
    }
    
}
