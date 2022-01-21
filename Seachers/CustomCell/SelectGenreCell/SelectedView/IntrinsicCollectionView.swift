//
//  IntrinsicCollectionView.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/20.
//

import UIKit

class IntrinsicCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            if !self.isScrollEnabled {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if self.isScrollEnabled {
            return super.intrinsicContentSize
        } else {
            self.layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
        }
    }
}

class CollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        var currentRowY: CGFloat = -1.0
        var currentRowX: CGFloat = 0
        for attribute in attributes where attribute.representedElementCategory == .cell {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                currentRowX = sectionInset.left
            }
            attribute.frame.origin.x = currentRowX
            currentRowX += attribute.frame.width + minimumInteritemSpacing
        }
        return attributes
    }
}

class PaddingLabel: UILabel {
    
    @IBInspectable var topPadding: CGFloat = 5
    @IBInspectable var bottomPadding: CGFloat = 5
    @IBInspectable var leftPadding: CGFloat = 10
    @IBInspectable var rightPadding: CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += (topPadding + bottomPadding)
        size.width += (leftPadding + rightPadding)
        return size
    }
}
