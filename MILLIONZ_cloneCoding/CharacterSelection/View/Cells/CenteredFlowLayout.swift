//
//  CenteredFlowLayout.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/07.
//

import UIKit

class CenteredFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        setupLayout()
    }
    
    func setupLayout() {
        scrollDirection = .horizontal
        minimumLineSpacing = 12
        minimumInteritemSpacing = 0
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { fatalError() }
        
        // itemSize
//        let itemHeight = collectionView.bounds.height - sectionInset.top - sectionInset.bottom
        itemSize = CGSize(width: 184, height: 281)
        
        // horizontal insets
        let horizontalInsets = (collectionView.bounds.width - itemSize.width) / 2
        sectionInset.left = horizontalInsets
        sectionInset.right = horizontalInsets
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        
        var proposedContentOffset = proposedContentOffset
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.bounds.size.width / 2
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        for layoutAttributes in layoutAttributesArray {
            let itemHorizontalCenter = layoutAttributes.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        var nextOffset = proposedContentOffset.x + offsetAdjustment
        let snapStep = itemSize.width + minimumLineSpacing
        
        func isValidOffset(_ offset: CGFloat) -> Bool {
            let minContentOffset = -collectionView.contentInset.left
            let maxContentOffset = collectionView.contentInset.left + collectionView.contentSize.width - itemSize.width
            return offset >= minContentOffset && offset <= maxContentOffset
        }
        
        repeat {
            proposedContentOffset.x = nextOffset
            let deltaX = proposedContentOffset.x - collectionView.contentOffset.x
            let velX = velocity.x
            
            if deltaX.sign.rawValue * velX.sign.rawValue != -1 {
                break
            }
            
            nextOffset += CGFloat(velocity.x.sign.rawValue) * snapStep
        } while isValidOffset(nextOffset)
        
        return proposedContentOffset
    }
}
