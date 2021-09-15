//
//  ExploreViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/1/21.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    
    var genreCells: [ExploreCellModel] = MockData.exploreData //[]
    var genreOfArtists: [String : [Artist]] = [:]
    
    var artistCells: [ExploreCellModel] = []
    
    var albumCells: [ExploreCellModel] = []
    
    func setAllGenres() {
        DatabaseManger.shared.getAllArtists { artists in
            for artist in artists {
                self.genreOfArtists[artist.genre]?.append(artist)
            }
            
            for genre in self.genreOfArtists {
                let imageString = genre.key.lowercased().replacingOccurrences(of: " ", with: "_")
                let cell = ExploreCellModel(imageName: imageString, genre: genre.key, artists: genre.value)
                self.genreCells.append(cell)
            }
            
        }
    }
    
    
    
//    func setAllAlbums() {
//        DatabaseManger.shared.getAllAlbums { albums in
//            for album in albums {
//                let imageString = album.albumArtworkURL
//                let cell = ExploreCellModel(
//                self.genreCells.append(cell)
//            }
//        }
//    }
    
    
    
    
    
    
}
