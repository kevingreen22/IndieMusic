//
//  MusicModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import Foundation

// MARK: Artist Class
class Artist: Hashable, Codable, Comparable {
    static func < (lhs: Artist, rhs: Artist) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.genre == rhs.genre &&
            lhs.imageURL == rhs.imageURL &&
            lhs.albums == rhs.albums &&
            lhs.timeStamp == rhs.timeStamp
    }
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.genre == rhs.genre &&
            lhs.imageURL == rhs.imageURL &&
            lhs.albums == rhs.albums &&
            lhs.timeStamp == rhs.timeStamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(genre)
        hasher.combine(imageURL)
        hasher.combine(albums)
        hasher.combine(timeStamp)
       
    }
    
    let id: UUID
    var name: String
    var genre: String
    var imageURL: URL?
    var albums: [Album]
    var timeStamp: TimeInterval
    
    init(id: UUID? = nil, name: String, genre: String, imageURL: URL?, albums: [Album]) {
        self.id = id ?? UUID()
        self.name = name
        self.genre = genre
        self.imageURL = imageURL
        self.albums = albums
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    public var mostRecentAlbumArtworkURL: URL {
        let sortedAlbums = albums.sorted(by: { $0.timeStamp < $1.timeStamp })
        if let mostRecentArtwork = sortedAlbums.last?.artworkURL {
            return mostRecentArtwork
        } else {
            return URL(fileURLWithPath: "album_artwork_placeholder")
        }
    }
    
    
}





// MARK: Album Class
class Album: Hashable, Identifiable, Equatable, Comparable, Codable {
    static func < (lhs: Album, rhs: Album) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.artistName == rhs.artistName &&
            lhs.artistID == rhs.artistID &&
            lhs.artworkURL == rhs.artworkURL &&
            lhs.songs == rhs.songs &&
            lhs.year == rhs.year &&
            lhs.genre == rhs.genre &&
            lhs.timeStamp == rhs.timeStamp
    }
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.artistName == rhs.artistName &&
            lhs.artistID == rhs.artistID &&
            lhs.artworkURL == rhs.artworkURL &&
            lhs.songs == rhs.songs &&
            lhs.year == rhs.year &&
            lhs.genre == rhs.genre &&
            lhs.timeStamp == rhs.timeStamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(artistName)
        hasher.combine(artistID)
        hasher.combine(artworkURL)
        hasher.combine(songs)
        hasher.combine(year)
        hasher.combine(genre)
        hasher.combine(timeStamp)
    }
    
    let id: UUID
    var title: String
    var artistName: String
    var artistID: String
    var artworkURL: URL?
    var songs: [Song]
    var year: String
    var genre: String
    var timeStamp: TimeInterval
    
    init(id: UUID? = nil, title: String, artistName: String, artistID: String, artworkURL: URL?, songs: [Song], year: String, genre: String) {
        self.id = id ?? UUID()
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
        self.id = UUID()
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
class Song: Hashable, Equatable, Codable, Comparable  {
    static func < (lhs: Song, rhs: Song) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.artistID == rhs.artistID &&
            lhs.lyrics == rhs.lyrics &&
            lhs.albumID == rhs.albumID &&
            lhs.url == rhs.url &&
            lhs.timeStamp == rhs.timeStamp
    }
    
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
    
    let id: UUID
    var title: String
    var albumTitle: String
    var artistName: String
    var genre: String
    var artistID: String
    var albumID: String
    var lyrics: String?
    var url: URL
    var timeStamp: TimeInterval
    
    init(id: UUID? = nil, title: String, albumTitle: String, artistName: String, genre: String, artistID: String, albumID: String, lyrics: String?, url: URL) {
        self.id = id ?? UUID()
        self.title = title
        self.albumTitle = albumTitle
        self.artistName = artistName
        self.genre = genre
        self.lyrics = lyrics
        self.artistID = artistID
        self.albumID = albumID
        self.url = url
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    init() {
        self.id = UUID()
        self.title = ""
        self.albumTitle = ""
        self.artistName = ""
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



