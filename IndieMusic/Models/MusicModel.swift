//
//  MusicModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import Foundation

// MARK: Artist Class

class Artist: Hashable, Codable {
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.albums == rhs.albums
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(albums)
       
    }
    
    let id: String
    var name: String
    var genre: String
    var imageURL: URL?
    var albums: [Album]?
    var timeStamp: TimeInterval
    
    init(name: String, genre: String, imageURL: URL?, albums: [Album]?) {
        self.id = UUID().uuidString
        self.name = name
        self.genre = genre
        self.imageURL = imageURL
        self.albums = albums
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    public var mostRecentAlbumArtworkURL: URL {
        if let album = albums?.sorted(), let mostRecentArtwork = album.last?.artworkURL {
            return mostRecentArtwork
        } else {
            return URL(fileURLWithPath: "album_artwork_placeholder")
        }
        
//        guard let album = albums.sorted() else { return }
//        guard let mostRecentArtwork = album.last?.artworkURL else {
//            return URL(fileURLWithPath: "album_artwork_placeholder")
//        }
//        return mostRecentArtwork
    }
    
    
}





// MARK: Album Class

class Album: Hashable, Equatable, Comparable, Codable {
    static func < (lhs: Album, rhs: Album) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.artistName == rhs.artistName &&
            lhs.artistID == rhs.artistID &&
            lhs.artworkURL == rhs.artworkURL &&
            lhs.songs == rhs.songs &&
            lhs.year == rhs.year
    }
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.artistName == rhs.artistName &&
            lhs.artistID == rhs.artistID &&
            lhs.artworkURL == rhs.artworkURL &&
            lhs.songs == rhs.songs &&
            lhs.year == rhs.year
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(artistName)
        hasher.combine(artistID)
        hasher.combine(artworkURL)
        hasher.combine(songs)
        hasher.combine(year)
    }
    
    let id: String
    var title: String
    var artistName: String
    var artistID: String
    var artworkURL: URL?
    var songs: [Song]
    var year: String
    var genre: String
    var timeStamp: TimeInterval
    
    init(title: String, artistName: String, artistID: String, artworkURL: URL?, songs: [Song], year: String, genre: String) {
        self.id = UUID().uuidString
        self.title = title
        self.artistName = artistName
        self.artistID = artistID
        self.artworkURL = artworkURL
        self.songs = songs
        self.year = year
        self.genre = genre
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    init() {
        self.id = UUID().uuidString
        self.title = ""
        self.artistName = ""
        self.artistID = ""
        self.artworkURL = URL(string: "")
        self.songs = []
        self.year = ""
        self.genre = ""
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    var albumArtworkURL: URL {
        guard let artworkURL = artworkURL else {
            return URL(fileURLWithPath: "album_artwork_placeholder")
        }
        return artworkURL
    }
    
}




// MARK: Song Class

class Song: Hashable, Equatable, Codable  {
    static func == (lhs: Song, rhs: Song) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.artistID == rhs.artistID &&
            lhs.lyrics == rhs.lyrics &&
            lhs.albumID == rhs.albumID &&
            lhs.url == rhs.url &&
            lhs.timeStamp == rhs.timeStamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(artistID)
        hasher.combine(lyrics)
        hasher.combine(albumID)
        hasher.combine(url)
        hasher.combine(timeStamp)
    }
    
    let id: String
    var title: String
    var genre: String
    var artistID: String
    var albumID: String
    var lyrics: String?
    var url: URL
    var timeStamp: TimeInterval
    
    init(title: String, genre: String, artistID: String, albumID: String, lyrics: String?, url: URL) {
        self.id = UUID().uuidString
        self.title = title
        self.genre = genre
        self.lyrics = lyrics
        self.artistID = artistID
        self.albumID = albumID
        self.url = url
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    init() {
        self.id = UUID().uuidString
        self.title = ""
        self.genre = ""
        self.lyrics = ""
        self.artistID = ""
        self.albumID = ""
        self.url = URL(fileURLWithPath: "")
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    var hasLyrics: Bool {
        if lyrics == "" || lyrics == nil {
            return false
        } else {
            return true
        }
    }
    
    func getLyrics() -> String {
        guard let _lyrics = lyrics else { return "" }
        return _lyrics
    }
    
    
    
}





struct Genres {
    static var names = ["Metal", "Blues", "R & B", "Hip Hop", "Rap", "Other"]
}
