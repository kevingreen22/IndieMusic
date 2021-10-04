//
//  ExploreViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/1/21.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    @Published var genreOfAlbums: [String : [Album]] = [:]
    @Published var index: Int = 0
    
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
            self.artists.append(contentsOf: artists)
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
            for album in albums {
                StorageManager.shared.downloadAlbumArtworkFor(albumID: album.id.uuidString, artistID: album.artistID) { image in
                    guard let image = image else { return }
                    self.albumArtworks.append(image)
                }
                
                self.albums.append(contentsOf: albums)
            }
        }
    }
    
    fileprivate func fetchAllSongs() {
        DatabaseManger.shared.fetchAllSongs { songs in
            self.songs.append(contentsOf: songs)
        }
    }
        
    
    
    
    func fetchBioImageFor(artist: Artist) -> UIImage {
        var bioImage = UIImage(named: "bio_placeholder")!
        StorageManager.shared.downloadArtistBioImageFor(artist: artist) { image in
            guard let image = image else { return }
            bioImage = image
        }
        return bioImage
    }
    
    func fetchAlbumArtworkFor(album: Album) -> UIImage {
        var artwork = UIImage(named: "album_artwork_placeholder")!
        StorageManager.shared.downloadAlbumArtworkFor(albumID: album.id.uuidString, artistID: album.artistID) { image in
            guard let image = image else { return }
            artwork = image
        }
        return artwork
    }
    
    
}
