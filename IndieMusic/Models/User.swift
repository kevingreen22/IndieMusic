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

struct User: Codable {
    var name: String
    var email: String
    var profilePictureData: Data?
    var favoriteArtists: [Artist]?
    var favoriteAlbums: [Album]?
    var favoriteSongs: [Song]?
    var recentlyAdded: [Album]?
    var isArtistOwner: Bool
    var artist: Artist?
    
    
    func getOwnerAlbums() -> [Album] {
        let nilAlbum: [Album] = []
        guard let _artist = artist else { return nilAlbum }
        guard let albums = _artist.albums else { return nilAlbum }
        return albums
    }
   
    
}

