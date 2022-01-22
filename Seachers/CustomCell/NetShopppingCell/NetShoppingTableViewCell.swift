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
    @IBOutlet weak var FavoriteButtom: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UrlButtom.layer.cornerRadius = 5
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
