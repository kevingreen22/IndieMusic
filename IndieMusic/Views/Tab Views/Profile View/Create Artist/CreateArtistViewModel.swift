//
//  CreateArtistViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

class CreateArtistViewModel: ObservableObject {
    
    @Published var addAlbum = false
    @Published var artistName = ""
    @Published var albums = ""
    @Published var genre = ""
    @Published var newGenreName = ""
    @Published var bioImage: UIImage? = nil
    @Published var pickImage: Bool? = false
    
    
    
    func createArtist(viewModel: ViewModel, completion: @escaping (Bool) -> Void) {
        let ownerArtist = Artist(name: artistName, genre: genre, imageURL: nil, albums: nil)
        DatabaseManger.shared.insert(artist: ownerArtist) { success in
            if success {
                viewModel.user.artist = ownerArtist
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}

