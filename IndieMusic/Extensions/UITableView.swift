//
//  UITableView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import Foundation
import SwiftUI

extension UITableView {
    
    /// edits List Views
    func setTableViewBackgroundGradient(_ topColor: UIColor, _ bottomColor: UIColor) {
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
