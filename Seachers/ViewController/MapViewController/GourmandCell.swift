//
//  taravelCell.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/11.
//

import UIKit

class GourmandCell: UICollectionViewCell {

    
    @IBOutlet weak var gourmandView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gourmandView.layer.cornerRadius = 10
        gourmandView.layer.masksToBounds = false
        gourmandView.layer.shadowOffset = CGSize(width: 1, height: 3)
        gourmandView.layer.shadowOpacity = 0.2
        gourmandView.layer.shadowRadius = 3
        // Initialization code
    }

}
