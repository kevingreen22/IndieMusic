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

class User: Codable {
    var name: String
    var email: String
    var profilePictureData: Data?
    var songListData: [Song]
    var favoriteArtists: [Artist]?
    var favoriteAlbums: [Album]?
    var favoriteSongs: [Song]?
    var recentlyAdded: [Album]?
    var artist: Artist?
    
    init(name: String, email: String, profilePictureData: Data?, songListData: [Song], favoriteArtists: [Artist]?, favoriteAlbums: [Album]?, favoriteSongs: [Song]?, recentlyAdded: [Album]?, artist: Artist?) {
        self.name = name
        self.email = email
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
   
    
}

