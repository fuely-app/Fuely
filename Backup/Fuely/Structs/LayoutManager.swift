//
//  LayoutManager.swift
//  Fuely
//
//  Created by Jarrod Norwell on 27/9/2025.
//

import Foundation
import UIKit

struct LayoutManager {
    static var main: UICollectionViewCompositionalLayout {
        .init { sectionIndex, layoutEnvironment in
            let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(300)))
            
            let group: NSCollectionLayoutGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                               heightDimension: .estimated(300)),
                                                             subitems: [item])
            group.interItemSpacing = .fixed(20)
            
            let header: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                              heightDimension: .estimated(44)),
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)
            header.pinToVisibleBounds = true
            
            let section: NSCollectionLayoutSection = .init(group: group)
            // section.boundarySupplementaryItems = [header]
            section.contentInsets = .init(top: sectionIndex == 0 ? 10 : 0, leading: 20, bottom: 20, trailing: 20)
            section.interGroupSpacing = 20
            return section
        }
    }
}
