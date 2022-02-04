//
//  NetShoppingTableViewCell.swift
//  Seachers
//
//  Created by 西林遼太郎 on 2022/01/16.
//

import UIKit

class NetShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var UrlButtom: UIButton!
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var NetShoppingView: UIView!
    @IBOutlet weak var valuationLabel: UILabel!
    @IBOutlet weak var valuationImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NetShoppingView.layer.cornerRadius = 10
        NetShoppingView.layer.masksToBounds = false
        NetShoppingView.layer.shadowOffset = CGSize(width: 1, height: 3)
        NetShoppingView.layer.shadowOpacity = 0.2
        NetShoppingView.layer.shadowRadius = 3
        
        UrlButtom.layer.cornerRadius = 5
        UrlButtom.layer.masksToBounds = false
        UrlButtom.layer.shadowOffset = CGSize(width: 1, height: 3)
        UrlButtom.layer.shadowOpacity = 0.2
        UrlButtom.layer.shadowRadius = 3
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
