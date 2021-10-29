//
//  String.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import Foundation
import SwiftUI

extension String {
    
    func underscoredDotAt() -> String {
        return self.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
    }
    
    func underscoredLowercased() -> String {
        return self.replacingOccurrences(of: " ", with: "_").lowercased()
    }
    
}
