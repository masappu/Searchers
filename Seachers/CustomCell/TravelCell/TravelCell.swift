//
//  TravelCell.swift
//  Seachers
//
//  Created by 近藤大伍 on 2022/01/12.
//

import UIKit

class TravelCell: UICollectionViewCell {

    
    @IBOutlet weak var travelView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var area_genreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        travelView.layer.cornerRadius = 10
        travelView.layer.masksToBounds = false
        travelView.layer.shadowOffset = CGSize(width: 1, height: 3)
        travelView.layer.shadowOpacity = 0.2
        travelView.layer.shadowRadius = 3
        
        detailButton.layer.cornerRadius = 5
        // Initialization code
    }

}
