//
//  LayoutManager.swift
//  Fuely
//
//  Created by Jarrod Norwell on 21/5/2026.
//

import UIKit

struct LayoutManager {
    static var main: UICollectionViewCompositionalLayout {
        let configuration: UICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20.0
        
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnvironment in
            let estimatedLayoutDimension: NSCollectionLayoutDimension = NSCollectionLayoutDimension.estimated(300)
            let halfWidthLayoutDimension: NSCollectionLayoutDimension = NSCollectionLayoutDimension.fractionalWidth(1.0)
            let fullWidthLayoutDimension: NSCollectionLayoutDimension = NSCollectionLayoutDimension.fractionalWidth(1.0)
            
            let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: halfWidthLayoutDimension,
                                                                          heightDimension: estimatedLayoutDimension)
            
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: fullWidthLayoutDimension,
                                                                           heightDimension: estimatedLayoutDimension)
            let boundarySupplementaryItemSize: NSCollectionLayoutSize = groupSize
            
            let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(20.0)
            
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: boundarySupplementaryItemSize,
                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                            alignment: .top)
            ]
            section.contentInsets.leading = 20.0
            section.contentInsets.trailing = 20.0
            section.interGroupSpacing = 20.0
            return section
        }, configuration: configuration)
    }
}
