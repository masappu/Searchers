//
//  ChoosingGenreCell.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/19.
//

import UIKit

class ChoosingGenreCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activationSelfSizing()
        
    }
    
    
    private func activationSelfSizing() {
        // iOS12 のときに Self-sizing が有効にならない対策
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
}
