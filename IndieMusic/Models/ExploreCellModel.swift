//
//  ExploreCellContent.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/17/21.
//

import Foundation
import SwiftUI

struct ExploreCellModel: Hashable, Comparable {
    static func < (lhs: ExploreCellModel, rhs: ExploreCellModel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.imageName == rhs.imageName &&
            lhs.image == rhs.image &&
            lhs.genre == rhs.genre &&
            lhs.albums == rhs.albums &&
            lhs.artists == rhs.artists
    }
    
    let id: UUID = UUID()
    let imageName: String?
    let image: UIImage?
    let genre: String
    let albums: [Album]
    let artists: [Artist]
    
    
    
}


