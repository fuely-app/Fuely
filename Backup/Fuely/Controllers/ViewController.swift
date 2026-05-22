//
//  ViewController.swift
//  Fuely
//
//  Created by Jarrod Norwell on 27/9/2025.
//

import MapKit
import OnboardingKit
import UIKit

class ViewController : UICollectionViewController {
    let api: API = .init()
    
    var dataSource: UICollectionViewDiffableDataSource<String, API.Item>? = nil
    var snapshot: NSDiffableDataSourceSnapshot<String, API.Item>? = nil,
        searchSnapshot: NSDiffableDataSourceSnapshot<String, API.Item>? = nil
    
    var brand: API.Brand? = nil
    var product: API.Product? = nil
    var region: API.Region? = nil
    var suburb: API.Suburb? = .perth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filteredElements: UIDeferredMenuElement = .uncached { completion in
            let brandElements: [UIAction] = API.Brand.allCases.sorted().map { brand in
                return .init(title: brand.string, subtitle: brand.id == nil ? "Unknown Identifier" : nil,
                             attributes: brand.id == nil ? .disabled : [],
                             state: self.brand == brand ? .on : .off) { _ in
                    self.brand = if self.brand == brand {
                        nil
                    } else {
                        brand
                    }
                    self.fetch()
                }
            }
            
            let productElements: [UIAction] = API.Product.allCases.sorted().map { product in
                return .init(title: product.description, state: self.product == product ? .on : .off) { _ in
                    self.product = if self.product == product {
                        nil
                    } else {
                        product
                    }
                    self.fetch()
                }
            }
            
            let regionElements: [UIAction] = API.Region.allCases.sorted().map { region in
                return .init(title: region.description, state: self.region == region ? .on : .off) { _ in
                    self.region = if self.region == region {
                        nil
                    } else {
                        region
                    }
                    self.fetch()
                }
            }
            
            let suburbElements: [UIAction] = API.Suburb.allCases.sorted().map { suburb in
                return .init(title: suburb.string, state: self.suburb == suburb ? .on : .off) { _ in
                    self.suburb = if self.suburb == suburb {
                        nil
                    } else {
                        suburb
                    }
                    self.fetch()
                }
            }
            
            completion([
                UIMenu(title: "Brands", children: brandElements),
                UIMenu(title: "Products", children: productElements),
                UIMenu(title: "Regions", children: regionElements),
                UIMenu(title: "Suburbs", children: suburbElements)
            ])
        }
        
        let searchController: UISearchController = .init(searchResultsController: nil)
        searchController.scopeBarActivation = .onSearchActivation
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Brand", "Trading Name", "Address"]
        navigationItem.preferredSearchBarPlacement = .stacked
        // navigationItem.searchController = searchController
        
        if let navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        navigationItem.largeTitleDisplayMode = .inline
        navigationItem.style = .browser
        navigationItem.largeTitle = "Fuely"
        navigationItem.title = navigationItem.largeTitle
        navigationItem.largeSubtitle = "Fetching prices..."
        navigationItem.subtitle = navigationItem.largeSubtitle
        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "line.3.horizontal.decrease"),
                                                  menu: .init(children: [filteredElements]))
        view.backgroundColor = .systemBackground
        
        let headerCellRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = .init(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var contentConfiguration = UIListContentConfiguration.extraProminentInsetGroupedHeader()
            if let dataSource = self.dataSource, let location = dataSource.sectionIdentifier(for: indexPath.section) {
                contentConfiguration.text = location
            }
            supplementaryView.contentConfiguration = contentConfiguration
            
        }
        
        let cellRegistration: UICollectionView.CellRegistration<Cell, API.Item> = .init { cell, indexPath, itemIdentifier in
            cell.set(item: itemIdentifier, index: indexPath.item + 1)
        }
        
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        guard let dataSource else {
            return
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: indexPath)
        }
        
        fetch()
    }
    
    func fetch() {
        snapshot = .init()
        guard let dataSource, var snapshot else {
            return
        }
        
        let task = Task { try await api.query(brand: brand, product: product, region: region, suburb: suburb) }
        Task {
            switch await task.result {
            case .success(let result):
                let region: String = if let region = result.region {
                    region.string
                } else {
                    "No Region"
                }
                
                let suburb: String = if let suburb = result.suburb {
                    suburb.string
                } else {
                    "No Suburb"
                }
                
                snapshot.appendSections(Array(Set(result.items.map(\.location).sorted())))
                snapshot.sectionIdentifiers.forEach { location in
                    snapshot.appendItems(result.items.filter { $0.location == location }.sorted(), toSection: location)
                }
                
                await dataSource.apply(snapshot)
                self.snapshot = snapshot
                
                navigationItem.largeSubtitle = "\(region), \(suburb) • \(result.items.count) price\(result.items.count == 1 ? "" : "s")"
                navigationItem.subtitle = navigationItem.largeSubtitle
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let dataSource, let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let directionalController: UINavigationController = .init(rootViewController: DirectionalController(item: item))
        directionalController.modalPresentationStyle = .fullScreen
        present(directionalController, animated: true)
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        searchSnapshot = .init()
        guard let dataSource, var searchSnapshot else {
            return
        }
        
        let task = Task {
            try await api.query()
        }
        
        Task {
            switch await task.result {
            case .success(let result):
                let filtered: [API.Item] = result.items.filter {
                    switch searchBar.selectedScopeButtonIndex {
                    case 0:
                        $0.brand.string.localizedCaseInsensitiveContains(text)
                    case 1:
                        $0.tradingName.localizedCaseInsensitiveContains(text)
                    case 2:
                        $0.address.localizedCaseInsensitiveContains(text)
                    default:
                        $0.brand.string.localizedCaseInsensitiveContains(text)
                    }
                }
                
                searchSnapshot.appendSections(Array(Set(filtered.map(\.location).sorted())))
                searchSnapshot.sectionIdentifiers.forEach { location in
                    searchSnapshot.appendItems(filtered.filter { $0.location == location }.sorted(), toSection: location)
                }
                
                await dataSource.apply(searchSnapshot)
                self.searchSnapshot = searchSnapshot
                
                navigationItem.largeSubtitle = "\(filtered.count) price\(filtered.count == 1 ? "" : "s")"
                navigationItem.subtitle = navigationItem.largeSubtitle
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let dataSource, let snapshot else {
            return
        }
        
        let region: String = if let region {
            region.string
        } else {
            "No Region"
        }
        
        let suburb: String = if let suburb {
            suburb.string
        } else {
            "No Suburb"
        }
        
        navigationItem.largeSubtitle = "\(region), \(suburb) • \(snapshot.itemIdentifiers.count) price\(snapshot.itemIdentifiers.count == 1 ? "" : "s")"
        navigationItem.subtitle = navigationItem.largeSubtitle
        
        self.searchSnapshot = nil
        Task {
            await dataSource.apply(snapshot)
        }
    }
}
