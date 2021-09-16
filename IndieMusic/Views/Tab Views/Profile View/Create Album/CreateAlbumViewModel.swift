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
    
    
    
    
    func createAlbum(viewModel: ViewModel, completion: @escaping (Bool) -> Void) {
        guard let ownerArtist = viewModel.user.artist,
              let genre = genre else {
            return
        }
        
        let artworkURL = URL(string: "")
        
        let album = Album(title: albumName, artistName: ownerArtist.name, artistID: ownerArtist.id, artworkURL: artworkURL, songs: [], year: year.description, genre: genre)
        
        DatabaseManger.shared.insert(album: album) { success in
            if success {
                guard let image = self.selectedImage else { return }
                StorageManager.shared.uploadAlbumArtworkImage(album: album, image: image) { success in
                    if success {
                        // append new album to users artist
                        ownerArtist.albums?.append(album)
                        
                        // save user to database
                        DatabaseManger.shared.insert(user: viewModel.user) { success in
                            if success {
                                completion(true)
                            } else { completion(false) }
                        }
                    } else { completion(false) }
                }
            } else { completion(false) }
        }
    }
    
    
    func getCurrentYear() -> Int {
        
        return 2021
    }

}
