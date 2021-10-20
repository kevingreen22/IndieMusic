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
    
    init() {
        fetchExplores()
    }
    
    
    func fetchExplores() {
        fetchAllArtists()
        fetchAllAlbums()
        fetchAllGenres()
        fetchAllSongs()
    }
    
    fileprivate func fetchAllArtists() {
        DatabaseManger.shared.fetchAllArtists { [weak self] artists in
            self?.artists.append(contentsOf: artists)
        }
        
    }
    
    fileprivate func fetchAllGenres() {
        DatabaseManger.shared.fetchAllAlbums { [weak self] albums in
            for album in albums {
                self?.genreOfAlbums[album.genre]?.append(album)
            }
        }
    }
    
    fileprivate func fetchAllAlbums() {
        DatabaseManger.shared.fetchAllAlbums { [weak self] albums in
            for album in albums {
                if !album.songs.isEmpty {
                    self?.albums.append(album)
                }
            }
        }
    }
    
    fileprivate func fetchAllSongs() {
        DatabaseManger.shared.fetchAllSongs { [weak self] songs in
            self?.songs.append(contentsOf: songs)
        }
    }
        
    
    
}
