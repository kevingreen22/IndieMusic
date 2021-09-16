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
    let imageName: String?
    let genre: String
    let artists: [Artist]
    
}


