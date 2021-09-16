//
//  CreateAlbumViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

class CreateAlbumViewModel: ObservableObject {

    @Published var albumName = ""
    @Published var genre: String?
    @Published var selectedImage: UIImage?
    @Published var year: Date = Date()
    @Published var showImagePicker = false
    @Published var pickImage: Bool? = false
    
    
    
    
    func getCurrentYear() -> Int {
        
        return 2021
    }

}
