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
    var songListData: [Song]
    var favoriteArtists: [Artist]?
    var favoriteAlbums: [Album]?
    var favoriteSongs: [Song]?
    var recentlyAdded: [Album]?
    var artist: Artist?
    
    init(name: String, email: String, profilePictureURL: URL?, songListData: [Song], favoriteArtists: [Artist]?, favoriteAlbums: [Album]?, favoriteSongs: [Song]?, recentlyAdded: [Album]?, artist: Artist?) {
        self.name = name
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.songListData = songListData
        self.favoriteArtists = favoriteArtists
        self.favoriteAlbums = favoriteAlbums
        self.favoriteSongs = favoriteSongs
        self.recentlyAdded = recentlyAdded
        self.artist = artist
    }
    
    
    var ownerAlbums: [Album] {
        guard let _artist = artist else { return [] }
        return _artist.albums
    }
    
    var ownerSongs: [Song] {
        var songs: [Song] = []
        guard let artist = artist else { return songs }
        
        for album in artist.albums {
            songs.append(contentsOf: album.songs)
        }
        return songs
    }
   
    func addSongToUserSongList(song: Song) {
        songListData.append(song)
    }
}

