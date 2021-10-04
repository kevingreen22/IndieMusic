//
//  Extensions.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/9/21.
//

import SwiftUI

// MARK: String Extension
extension String {
    
    func underscoredDotAt() -> String {
        return self.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
    }
    
}



// MARK: Color Extension
extension Color {
    
    static var mainApp: Color {
        Color("MainApp")
    }
    
    static var appSecondary: Color {
        Color("SecondaryApp")
    }
    
    static var tabBarBackground: Color {
        Color("TabBarBackground")
    }
    
}




// MARK: TimeInterval - formatter for currently playing views
extension TimeInterval {
    
    func timeFormat(unitsAllowed: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = unitsAllowed
        formatter.zeroFormattingBehavior = .pad
        guard let output = formatter.string(from: self) else { return "0:00" }
        return output
    }

}





// MARK: View

extension View {
    public func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    public func getSafeArea() -> UIEdgeInsets {
        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return null }
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return null }
        return safeArea
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
        navigationBar.barTintColor = UIColor(Color.mainApp)
        
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






