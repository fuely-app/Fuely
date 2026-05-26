//
//  StationsController.swift
//  Fuely
//
//  Created by Jarrod Norwell on 21/5/2026.
//

import UIKit

class StationsController : UICollectionViewController {
    var dataSource: UICollectionViewDiffableDataSource<String, API.Item>? = nil
    var snapshot: NSDiffableDataSourceSnapshot<String, API.Item>? = nil,
        searchSnapshot: NSDiffableDataSourceSnapshot<String, API.Item>? = nil
    
    var api: API = API()
    
    var brand: API.Brand? = nil
    var product: API.Product? = nil
    var region: API.Region? = nil
    var suburb: API.Suburb? = nil
    
    var toolbar: UIToolbar = UIToolbar()
    
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
            
            completion([
                UIMenu(title: "Company", image: UIImage(systemName: "building.fill"),
                       children: brandElements),
                UIMenu(title: "Type", image: UIImage(systemName: "fuelpump.fill"),
                       children: productElements),
                UIMenu(title: "Region", image: UIImage(systemName: "globe.asia.australia.fill"),
                       children: regionElements),
                UIAction(title: "Surrounding", state: UserDefaults.standard.bool(forKey: "fuely.includeSurrounding") ? .on : .off) { action in
                    var old: Bool =  UserDefaults.standard.bool(forKey: "fuely.includeSurrounding")
                    old.toggle()
                    UserDefaults.standard.set(old, forKey: "fuely.includeSurrounding")
                    
                    self.fetch()
                }
            ])
        }
        
        if let navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        navigationItem.largeTitle = "Stations"
        navigationItem.trailingItemGroups = [
            UIBarButtonItemGroup(barButtonItems: [
                UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"),
                                menu: UIMenu(preferredElementSize: .medium,
                                             children: [filteredElements]))
            ], representativeItem: nil)
        ]
        navigationItem.style = .browser
        navigationItem.title = navigationItem.largeTitle
        // navigationItem.subtitle = "Searching fuel stations"
        view.backgroundColor = .systemBackground
        
        let done: UIBarButtonItem = UIBarButtonItem(systemItem: .search, primaryAction: UIAction { action in
            guard let searchController: UISearchController = self.navigationItem.searchController else {
                return
            }
            
            searchController.searchBar.endEditing(false)
            self.searchBarSearchButtonClicked(searchController.searchBar)
        })
        done.style = .prominent
        
        toolbar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            done
        ]
        
        toolbar.sizeToFit()
        toolbar.frame.size.height += 20.0
        
        let searchController: UISearchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.scopeBarActivation = .onSearchActivation
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Address", "$", "$$$"]
        navigationItem.searchController = searchController
        
        
        let headerCellRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = .init(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var contentConfiguration = UIListContentConfiguration.extraProminentInsetGroupedHeader()
            if let dataSource = self.dataSource, let location = dataSource.sectionIdentifier(for: indexPath.section) {
                contentConfiguration.text = location.capitalized
            }
            supplementaryView.contentConfiguration = contentConfiguration
            
        }
        
        let cellRegistration: UICollectionView.CellRegistration<StationCell, API.Item> = .init { cell, indexPath, itemIdentifier in
            cell.set(station: itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell: StationCell = collectionView.cellForItem(at: indexPath) as? StationCell else {
            return
        }
        
        UINotificationFeedbackGenerator(view: cell).notificationOccurred(.success)
        
        guard let dataSource: UICollectionViewDiffableDataSource<String, API.Item>,
              let item: API.Item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        if let tabBarController: TabController = tabBarController as? TabController {
            let barButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.left"), primaryAction: UIAction { action in
                tabBarController.selectedStation = nil
                _ = self.navigationItem.trailingItemGroups.remove(at: 0)
                
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            })
            barButtonItem.style = .prominent
            barButtonItem.tintColor = .systemRed
            
            if tabBarController.selectedStation == nil {
                navigationItem.trailingItemGroups.insert(UIBarButtonItemGroup(barButtonItems: [
                    barButtonItem
                ], representativeItem: nil), at: 0)
            }
            
            tabBarController.selectedStation = item
        }
    }
    
    func fetch() {
        snapshot = .init()
        guard let dataSource, var snapshot else {
            return
        }
        
        let task = Task {
            try await api.query(brand: brand,
                                product: product,
                                region: region,
                                suburb: suburb,
                                surrounding: UserDefaults.standard.bool(forKey: "fuely.includeSurrounding"))
        }
        
        Task {
            switch await task.result {
            case .success(let result):
                let uniqueLocations: [String] = result.items.reduce(into: [String]()) { partialResult, item in
                    if !partialResult.contains(item.location) {
                        partialResult.append(item.location)
                    }
                }
                
                snapshot.appendSections(uniqueLocations.sorted(by: { lhs, rhs in
                    lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
                }))
                
                uniqueLocations.forEach { location in
                    snapshot.appendItems(result.items.filter { item in
                        item.location == location
                    }.sorted(), toSection: location)
                }
                
                await dataSource.apply(snapshot)
                self.snapshot = snapshot
                
                navigationItem.largeSubtitle = "\(result.items.count) station\(result.items.count == 1 ? "" : "s") available"
                navigationItem.subtitle = navigationItem.largeSubtitle
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
}

extension StationsController : UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if [1, 2].contains(selectedScope) {
            searchBar.inputAccessoryView = toolbar
            searchBar.keyboardType = .decimalPad
        } else {
            searchBar.inputAccessoryView = nil
            searchBar.keyboardType = .default
        }
        
        searchBar.reloadInputViews()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let dataSource, let snapshot else {
            return
        }
        
        if !searchSnapshot.isNil {
            searchSnapshot = nil
        }
        
        Task {
            await dataSource.apply(snapshot)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text: String = searchBar.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let selectedScopeButtonIndex: Int = searchBar.selectedScopeButtonIndex
        
        let trimmedText: String = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        searchSnapshot = NSDiffableDataSourceSnapshot<String, API.Item>()
        guard let dataSource, let snapshot, var searchSnapshot else {
            return
        }
        
        searchSnapshot.appendSections(["Search Results"])
        searchSnapshot.appendItems(snapshot.itemIdentifiers.filter { itemIdentifier in
            return switch selectedScopeButtonIndex {
            case 0:
                itemIdentifier.address.localizedCaseInsensitiveContains(trimmedText)
            case 1:
                itemIdentifier.price <= 100 * (Double(trimmedText) ?? 0)
            case 2:
                itemIdentifier.price >= 100 * (Double(trimmedText) ?? 0)
            default:
                itemIdentifier.brand.string.localizedCaseInsensitiveContains(trimmedText)
            }
        }.sorted(), toSection: "Search Results")
        
        Task {
            await dataSource.apply(searchSnapshot)
        }
    }
}
