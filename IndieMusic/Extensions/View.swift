//
//  View.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import Foundation
import SwiftUI


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
    
    #if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif
 
    
}
