//
//  ExploreViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/1/21.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    
    @Published var genreCells: [ExploreCellModel] = MockData.exploreData //[]
    @Published var genreOfArtists: [String : [Artist]] = [:]
    
    @Published var artistCells: [ExploreCellModel] = []
    
    @Published var albumCells: [ExploreCellModel] = []
    
    
    
    
    @Published var songs: [Song] = []
    
    func getSongs() {
        DatabaseManger.shared.getAllSongs { songs in
            self.songs = songs
        }
    }
    
    
    
    
    
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
