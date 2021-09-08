//
//  ActiveSheet.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/2/21.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case createArtist
    case createAlbum
    case uploadSong
    
    var id: Int { hashValue }
    
}
