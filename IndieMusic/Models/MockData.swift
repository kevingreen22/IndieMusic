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
    
    private init() {
        var artist: Artist {
            let artistID: UUID = UUID(uuidString: "brokeneck")!
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
            
            let mockAlbum = Album(
                title: "Hellfest EP",
                artistName: "Brokeneck",
                artistID: artistID.uuidString,
                artworkURL: URL(string: "artists/brokeneck/hellfest_ep/album_artwork.png"),
                songs: [mockSong1, mockSong2, mockSong3],
                year: "2009",
                genre: "Metal")
            
            let artist = Artist(
                id: artistID,
                name: "Brokeneck",
                genre: "Metal",
                imageURL: URL(string: "artists/brokeneck/artist_photo.png"),
                albums: [mockAlbum, mockAlbum, mockAlbum]
            )
            
            return artist
        }
        self.artists = [artist]
        
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
        
        self.exploreVM.albums = albums
        self.exploreVM.artists = artists
        self.exploreVM.songs = songs
        self.exploreVM.genreOfAlbums = genresOfAlbums
        
        self.currentlyPlaingVM.album = albums.first!
        self.currentlyPlaingVM.song = albums.first!.songs.first!
        
    }
    
    
    
    let user: User
    let artists: [Artist]
    
    let mainVM = MainViewModel()
    let profileVM = ProfileViewModel()
    let exploreVM = ExploreViewModel()
    let currentlyPlaingVM = CurrentlyPlayingViewModel()
    let signinVM = SigninViewModel()
        
    
    var albums: [Album] {
        var albumNames: [Album] = []
        for artist in artists {
            for album in artist.albums {
                albumNames.append(album)
            }
        }
        
        return albumNames
    }
    
    var songs: [Song] {
        var songs: [Song] = []
        for artist in artists {
            for album in artist.albums {
                for song in album.songs {
                    songs.append(song)
                }
            }
        }
        
        return songs
    }
    
    var genresOfAlbums: [String : [Album]] {
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
