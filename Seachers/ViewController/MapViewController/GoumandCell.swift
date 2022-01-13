//
//  taravelCell.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/11.
//

import UIKit

class GoumandCell: UICollectionViewCell {

    
    @IBOutlet weak var goumandView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goumandView.layer.cornerRadius = 10
        goumandView.layer.masksToBounds = false
        goumandView.layer.shadowOffset = CGSize(width: 1, height: 3)
        goumandView.layer.shadowOpacity = 0.2
        goumandView.layer.shadowRadius = 3
        // Initialization code
    }

}
