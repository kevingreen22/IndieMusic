//
//  ActiveSheet.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/2/21.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case signIn
    case paywall
    case imagePicker(sourceType: UIImagePickerController.SourceType, picking: PickingType)
    case documentPicker(picking: PickingType)
    
    var id: Int { UUID().hashValue }
    
}




enum PickingType {
    case bioImage
    case albumImage
    case mp3
}
