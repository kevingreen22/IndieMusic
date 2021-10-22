//
//  UINavigationController.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import Foundation
import SwiftUI

extension UINavigationController {
    
    /// edits NavigationViews
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()//.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationBar.tintColor = .black
        navigationBar.barTintColor = UIColor(Color.theme.primary)
        
        let tableView = UITableView.appearance()
        tableView.backgroundColor = .systemBackground
        
//        let dominantColors = DominantColors.getDominantColors(image: image)
//        tableView.setTableViewBackgroundGradient(dominantColors.0, dominantColors.1)
        
        let tableViewCell = UITableViewCell.appearance()
        tableViewCell.backgroundColor = .clear
        
    }
}

