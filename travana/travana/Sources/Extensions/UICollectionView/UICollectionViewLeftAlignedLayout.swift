//
//  UICollectionViewLeftAlignedLayout.swift
//  travana
//
//  Created by Domen Kralj on 25/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

/**
 *  Simple UICollectionViewFlowLayout that aligns the cells to the left (or top) rather than justify them
 *
 *  Based on https://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout
 */
open class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map { $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath)! : $0 }
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes,
            collectionView != nil else {
            // should never happen
            return nil
        }
        if scrollDirection == .vertical {
            // if the current frame, once stretched to the full row intersects the previous frame then they are on the same row
            if indexPath.item != 0,
                let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame,
                currentItemAttributes.frame.intersects(CGRect(x: -.infinity, y: previousFrame.origin.y, width: .infinity, height: previousFrame.size.height)) {
                // the next item on a row
                currentItemAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
            } else {
                // the first item on a row is section aligned
                currentItemAttributes.frame.origin.x = evaluatedSectionInsetForSection(at: indexPath.section).left
            }
        } else {
            // if the current frame, once stretched to the full column intersects the previous frame then they are on the same column
            if indexPath.item != 0,
                let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame,
                currentItemAttributes.frame.intersects(CGRect(x: previousFrame.origin.x, y: -.infinity, width: previousFrame.size.width, height: .infinity)) {
                // the next item on a column
                currentItemAttributes.frame.origin.y = previousFrame.origin.y + previousFrame.size.height + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
            } else {
                // the first item on a column is section aligned
                currentItemAttributes.frame.origin.y = evaluatedSectionInsetForSection(at: indexPath.section).top
            }
        }
        return currentItemAttributes
    }
    
    func evaluatedMinimumInteritemSpacingForSection(at section: NSInteger) -> CGFloat {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    func evaluatedSectionInsetForSection(at index: NSInteger) -> UIEdgeInsets {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, insetForSectionAt: index) ?? sectionInset
    }
}
