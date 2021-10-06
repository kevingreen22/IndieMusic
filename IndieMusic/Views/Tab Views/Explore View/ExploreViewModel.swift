//
//  ExploreViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/1/21.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    
    static let gridCellSize: CGFloat = 150
    
    @Published var searchText: String = ""
    
    @Published var genreOfAlbums: [String : [Album]] = [:]
    @Published var albumsForGenre: [Album] = []
    
    @Published var artists: [Artist] = []
    
    @Published var albums: [Album] = []
    @Published var albumArtworks: [UIImage] = []
    
    @Published var songs: [Song] = []
    
    
    
    
    func fetchExplores() {
        fetchAllArtists()
        fetchAllAlbums()
        fetchAllGenres()
        fetchAllSongs()
    }
    
    fileprivate func fetchAllArtists() {
        DatabaseManger.shared.fetchAllArtists { artists in
            self.artists.append(contentsOf: artists.prefix(10))
        }
    }
    
    fileprivate func fetchAllGenres() {
        DatabaseManger.shared.fetchAllAlbums { albums in
            for album in albums {
                self.genreOfAlbums[album.genre]?.append(album)
            }
        }
    }
    
    fileprivate func fetchAllAlbums() {
        DatabaseManger.shared.fetchAllAlbums { albums in
            self.albums.append(contentsOf: albums.prefix(10))
        }
    }
    
    fileprivate func fetchAllSongs() {
        DatabaseManger.shared.fetchAllSongs { songs in
            self.songs.append(contentsOf: songs)
        }
    }
        
    
    
}
