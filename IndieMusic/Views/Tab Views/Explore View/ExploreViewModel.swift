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
    
    var genreOfAlbums: [String : [Album]] = [:]
    var albumsForGenre: [Album] = []
    
    var artists: [Artist] = []
    
    var albums: [Album] = []
    
    var songs: [Song] = []
    
    init() {
        fetchAll()
    }
    
    
    fileprivate func fetchAll() {
        DatabaseManger.shared.fetchAllArtists { [weak self] artists in
            self?.artists.append(contentsOf: artists)
            
            for artist in artists {
                for album in artist.albums {
                    
                    self?.genreOfAlbums[album.genre]?.append(album)
                    
                    if !album.songs.isEmpty {
                        self?.albums.append(album)
                    }
                    
                    self?.songs.append(contentsOf: album.songs)
                    
                }
            }
        }
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
