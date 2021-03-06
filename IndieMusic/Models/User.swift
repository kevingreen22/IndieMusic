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
    var favoriteArtists: [Artist]
    var favoriteAlbums: [Album]
    var favoriteSongs: [Song]
    var recentlyAdded: [Album]
    var artist: Artist?
    
    init(name: String, email: String, profilePictureURL: URL?, profilePictureData: Data?, songListData: [Song], favoriteArtists: [Artist], favoriteAlbums: [Album], favoriteSongs: [Song], recentlyAdded: [Album], artist: Artist?) {
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
    
//    init() {
//        self.name = ""
//        self.email = ""
//        self.profilePictureURL = nil
//        self.profilePictureData = nil
//        self.songListData = []
//        self.favoriteArtists = []
//        self.favoriteAlbums = []
//        self.favoriteSongs = []
//        self.recentlyAdded = []
//        self.artist = nil
//    }
    
    
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
    
    func delete(song: Song) {
        guard let album = ownerAlbums.first(where: { album in
            album.id.uuidString == song.albumID
        }) else { return }
        
        album.songs.removeAll(where: { $0 == song })
    }
    
}

