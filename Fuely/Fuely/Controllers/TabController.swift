//
//  TabController.swift
//  Fuely
//
//  Created by Jarrod Norwell on 21/5/2026.
//

import UIKit

class TabController : UITabBarController {
    var selectedStation: API.Item? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabs = [
            UITab(title: "Stations", image: UIImage(systemName: "fuelpump"), identifier: "stations") { tab in
                UINavigationController(rootViewController: StationsController(collectionViewLayout: LayoutManager.main))
            },
            UITab(title: "Compass", image: UIImage(systemName: "safari"), identifier: "compass") { tab in
                CompassController()
            },
            UITab(title: "Map", image: UIImage(systemName: "map"), identifier: "map") { tab in
                MapController()
            }
        ]
        view.backgroundColor = .systemBackground
    }
}
