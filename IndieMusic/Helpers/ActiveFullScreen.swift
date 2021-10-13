//
//  ActiveFullScreen.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/7/21.
//

import SwiftUI


enum ActiveFullScreen: Identifiable {
    case createArtist
    case createAlbum
    case uploadSong
    case forgotPassword
    case createAccount
//    case imagePicker(sourceType: UIImagePickerController.SourceType, picking: PickingType)
//    case documentPicker(picking: PickingType)
//
    var id: Int { UUID().hashValue }
    
}
