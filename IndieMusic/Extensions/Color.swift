//
//  Color.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    
}



struct ColorTheme {
    var primary = Color("AppPrimary")
    var appSecondary = Color("AppSecondary")
    var tabBarBackground = Color("TabBarBackground")
    var primaryText = Color("PrimaryText")
    var secondaryText = Color("SecondaryText")
}
