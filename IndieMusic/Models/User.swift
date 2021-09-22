//
//  User.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

// Attributions
//
// <div>Icons made by <a href="https://www.flaticon.com/authors/xnimrodx" title="xnimrodx">xnimrodx</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

import Foundation
import UIKit

class User: Codable {
    var name: String
    var email: String
    var profilePictureURL: URL?
    var profilePictureData: Data?
    var songListData: [Song]
    var favoriteArtists: [Artist]?
    var favoriteAlbums: [Album]?
    var favoriteSongs: [Song]?
    var recentlyAdded: [Album]?
    var artist: Artist?
    
    init(name: String, email: String, profilePictureURL: URL?, profilePictureData: Data?, songListData: [Song], favoriteArtists: [Artist]?, favoriteAlbums: [Album]?, favoriteSongs: [Song]?, recentlyAdded: [Album]?, artist: Artist?) {
        self.name = name
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.profilePictureData = profilePictureData
        self.songListData = songListData
        self.favoriteArtists = favoriteArtists
        self.favoriteAlbums = favoriteAlbums
        self.favoriteSongs = favoriteSongs
        self.recentlyAdded = recentlyAdded
        self.artist = artist
    }
    
    
    func getOwnerAlbums() -> [Album] {
        let nilAlbum: [Album] = []
        guard let _artist = artist else { return nilAlbum }
        guard let albums = _artist.albums else { return nilAlbum }
        return albums
    }
    
    func getOwnerSongs() -> [UIImage? : [Song]] {
        var songs: [UIImage? : [Song]] = [:]
        guard let artist = artist else { return songs }
        guard let albums = artist.albums else { return songs }
        
        for album in albums {
            StorageManager.shared.downloadAlbumArtwork(for: album.id, artistID: album.artistID) { image in
                if let image = image {
                    songs.updateValue(album.songs, forKey: image)
                } else {
                    songs.updateValue(album.songs, forKey: nil)
                }
            }
        }
        return songs
    }
   
    
}

