//
//  ExploreViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/1/21.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    
    var genreOfArtists: [String : [Artist]] = [:]
    var exploreCells: [ExploreCellModel] = []
    
    
    
    
    func getAllGenres() {
        DatabaseManger.shared.getAllArtists { artists in
            for artist in artists {
                self.genreOfArtists[artist.genre]?.append(artist)
            }
            
            for genre in self.genreOfArtists {
                let imageString = genre.key.lowercased().replacingOccurrences(of: " ", with: "_")
                let cell = ExploreCellModel(genre: genre.key, imageName: imageString, artists: genre.value)
                self.exploreCells.append(cell)
            }
            
        }
    }
    
    
}
