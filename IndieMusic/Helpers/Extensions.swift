//
//  Extensions.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/9/21.
//

import SwiftUI

// MARK: Color Extension
extension Color {
    
    static var appMainColor: Color {
        Color(.sRGB, red: 250, green: 200, blue: 55, opacity: 1.0)
    }
    
    static var appSecondaryColor: Color {
        Color(.sRGB, red: 250, green: 200, blue: 80, opacity: 1.0)
    }
    
    
    
    
}


// MARK: UINavigationController Extension. edits NavigationViews
extension UINavigationController {
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()//.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationBar.tintColor = .black
        
        let tableView = UITableView.appearance()
        tableView.backgroundColor = .systemBackground
        
//        let dominantColors = DominantColors.getDominantColors(image: image)
//        tableView.setTableViewBackgroundGradient(dominantColors.0, dominantColors.1)
        
        let tableViewCell = UITableViewCell.appearance()
        tableViewCell.backgroundColor = .clear
        
    }
}

// MARK: UITableView Extension, edits List Views
extension UITableView {
    
    func setTableViewBackgroundGradient(_ topColor:UIColor, _ bottomColor:UIColor) {
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations

        gradientLayer.frame = self.bounds
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundView = backgroundView
    }
}





