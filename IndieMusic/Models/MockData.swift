//
//  MockData.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}


class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    var user: User? = nil
    
    var artists: [Artist] = []
    var albums: [Album] = []
    var songs: [Song] = []
    var genresOfAlbums: [String : [Album]] = [:]
    
    let mainVM = MainViewModel()
    let profileVM = ProfileViewModel()
    let exploreVM = ExploreViewModel()
    let currentlyPlaingVM = CurrentlyPlayingViewModel()
    let signinVM = SigninViewModel()
       
    
    private init() {
        var artist: Artist {
            let artistID: UUID = UUID()
            let albumIDs = ["album1", "album2", "album3"]
            
            let mockSong1 = Song(
            title: "Electric Sloth",
            albumTitle: "Hellfest EP",
            artistName: "Brokeneck",
            genre: "Metal",
            artistID: artistID.uuidString,
            albumID: albumIDs[0],
            lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
            url: URL(fileURLWithPath: "artists/brokeneck/hellfest_ep/electric_sloth.mp3")
        )
            
            let mockSong2 = Song(
            title: "Crush, Kill, Destroy",
            albumTitle: "Hellfest EP",
            artistName: "Brokeneck",
            genre: "Metal",
            artistID: artistID.uuidString,
            albumID: albumIDs[1],
            lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
            url: URL(fileURLWithPath: "artists/brokeneck/hellFest_ep/crush,_kill,destroy.mp3")
        )
            
            let mockSong3 = Song(
            title: "Penguins Are Awfly Cute",
            albumTitle: "Hellfest EP",
            artistName: "Brokeneck",
            genre: "Metal",
            artistID: artistID.uuidString,
            albumID: albumIDs[2],
            lyrics: nil,
            url: URL(fileURLWithPath: "artists/brokeneck/hellFest_ep/penguins_are_awfly_cute.mp3")
        )
            
            let album1 = Album(
                id: UUID(uuidString: albumIDs[0]),
                title: "Hellfest EP",
                artistName: "Brokeneck",
                artistID: artistID.uuidString,
                artworkURL: URL(string: "artists/brokeneck/hellfest_ep/album_artwork.png"),
                songs: [mockSong1, mockSong2, mockSong3],
                year: "2009",
                genre: "Metal")
            
            let album2 = Album(
                id: UUID(uuidString: albumIDs[1]),
                title: "Garage Days",
                artistName: "Brokeneck",
                artistID: artistID.uuidString,
                artworkURL: URL(string: "artists/brokeneck/hellfest_ep/album_artwork.png"),
                songs: [mockSong1, mockSong2, mockSong3],
                year: "2009",
                genre: "R & B")
            
            let album3 = Album(
                id: UUID(uuidString: albumIDs[2]),
                title: "Penguins",
                artistName: "Brokeneck",
                artistID: artistID.uuidString,
                artworkURL: URL(string: "artists/brokeneck/hellfest_ep/album_artwork.png"),
                songs: [mockSong1, mockSong2, mockSong3],
                year: "2009",
                genre: "Rap")
            
            let artist = Artist(
                id: artistID,
                name: "Brokeneck",
                genre: "Metal",
                imageURL: URL(string: "artists/brokeneck/artist_photo.png"),
                albums: [album1, album2, album3]
            )
            
            return artist
        }
        self.artists = [artist, artist, artist]
        
        let a = setAlbums()
        let s = setSongs()
        let ga = setGenresOfAlbums()
        
        self.albums = a
        self.songs = s
        self.genresOfAlbums = ga
        
        self.exploreVM.artists = artists
        self.exploreVM.albums = a
        self.exploreVM.songs = s
        self.exploreVM.genreOfAlbums = ga
        
        self.currentlyPlaingVM.album = a.first!
        self.currentlyPlaingVM.song = a.first!.songs.first!
        
        self.user = User(
            name: "Kevin",
            email: "Bbongrip@gmail.com",
            profilePictureURL: nil,
            profilePictureData: nil,
            songListData: [],
            favoriteArtists: [artists.first!],
            favoriteAlbums: [artists.first!.albums.first!],
            favoriteSongs: [artists.first!.albums.first!.songs.first!],
            recentlyAdded: [],
            artist: artists.first!
        )
        
        self.mainVM.user = self.user
        self.mainVM.selectedTab = 2
        self.mainVM.showSplash = false
    }
    
    
    
    func setAlbums() -> [Album]{
        var albumNames: [Album] = []
        for artist in artists {
            for album in artist.albums {
                albumNames.append(album)
            }
        }
        
        return albumNames
    }
    
    func setSongs() -> [Song] {
        var songs: [Song] = []
        for artist in artists {
            for album in artist.albums {
                songs.append(contentsOf: album.songs)
            }
        }
        
        return songs
    }
    
    func setGenresOfAlbums() -> [String: [Album]] {
        var genreOfAlbums: [String : [Album]] = [:]
        for artist in artists {
            for album in artist.albums {
                genreOfAlbums.updateValue(artist.albums, forKey: album.genre)
//                genreOfAlbums[album.genre]?.append(album)
            }
        }
        
        return genreOfAlbums
    }
    
    
    
    
}
