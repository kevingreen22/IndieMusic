//
//  ExploreCellContent.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/17/21.
//

import Foundation
import SwiftUI



struct ExploreCellModel: Hashable {
    let id: String = UUID().uuidString
    let genre: String
    let imageName: String?
    let artists: [Artist]
    
}


